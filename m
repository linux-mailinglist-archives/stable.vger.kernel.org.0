Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054354BE5D5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349433AbiBUJ1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350135AbiBUJ1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA0062DF;
        Mon, 21 Feb 2022 01:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E17060018;
        Mon, 21 Feb 2022 09:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8993CC340E9;
        Mon, 21 Feb 2022 09:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434704;
        bh=U9FilwgzUHxGI/pxCJNkQLuIALWeDECqZfIDidr69OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXfn0foL4S4mJeT4ybcZiYQB9fK7PtP1BpLi4sY9uWYeCQeuv/qUm/cD7l6vTdGC2
         IyDAVuNGfhdw9yCco1UQvvU+poAuxeNs+o2vj/cig2FCbNUilZ7KD7fr0UshaMXHXC
         /yTfiiBdTDUU8RIEXRrdGps0pqfTn+wXajQM7LkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com,
        Wen Gu <guwen@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 101/196] net/smc: Avoid overwriting the copies of clcsock callback functions
Date:   Mon, 21 Feb 2022 09:48:53 +0100
Message-Id: <20220221084934.322831512@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Gu <guwen@linux.alibaba.com>

commit 1de9770d121ee9294794cca0e0be8fbfa0134ee8 upstream.

The callback functions of clcsock will be saved and replaced during
the fallback. But if the fallback happens more than once, then the
copies of these callback functions will be overwritten incorrectly,
resulting in a loop call issue:

clcsk->sk_error_report
 |- smc_fback_error_report() <------------------------------|
     |- smc_fback_forward_wakeup()                          | (loop)
         |- clcsock_callback()  (incorrectly overwritten)   |
             |- smc->clcsk_error_report() ------------------|

So this patch fixes the issue by saving these function pointers only
once in the fallback and avoiding overwriting.

Reported-by: syzbot+4de3c0e8a263e1e499bc@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Link: https://lore.kernel.org/r/0000000000006d045e05d78776f6@google.com
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -649,14 +649,17 @@ static void smc_fback_error_report(struc
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
 	struct sock *clcsk;
+	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
 	if (!smc->clcsock) {
-		mutex_unlock(&smc->clcsock_release_lock);
-		return -EBADF;
+		rc = -EBADF;
+		goto out;
 	}
 	clcsk = smc->clcsock->sk;
 
+	if (smc->use_fallback)
+		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -683,8 +686,9 @@ static int smc_switch_to_fallback(struct
 		smc->clcsock->sk->sk_user_data =
 			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	}
+out:
 	mutex_unlock(&smc->clcsock_release_lock);
-	return 0;
+	return rc;
 }
 
 /* fall back during connect */



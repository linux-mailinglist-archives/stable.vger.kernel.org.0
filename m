Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A655A4A4D
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiH2Lgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiH2Lf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B127E80D;
        Mon, 29 Aug 2022 04:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D29A5B80FA0;
        Mon, 29 Aug 2022 11:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4534CC43151;
        Mon, 29 Aug 2022 11:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771599;
        bh=/92fL+7tW0QBg5vD25tOhzrYyIWIUzFk26TKpw5MrTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6zfe8nnvb8Gdtl0gz3PrT0g6Fa4d58K7Q0boWH5F2yLKCyKsiJPFSr92UHDpBDTt
         xABQ5I4ahHBNTMoru3gSTauguorlQPB5Dq1RRg604lbNZo1QAK8cMvGoFIaO+8euMj
         1puClfPKHL3hXkF1YCfdWCuQ6erLBpOuuOJ6A4Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Yonglong Li <liyonglong@chinatelecom.cn>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 124/136] mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb
Date:   Mon, 29 Aug 2022 12:59:51 +0200
Message-Id: <20220829105809.765999180@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yonglong Li <liyonglong@chinatelecom.cn>

commit 3ef3905aa3b5b3e222ee6eb0210bfd999417a8cc upstream.

Got crash when doing pressure test of mptcp:

===========================================================================
dst_release: dst:ffffa06ce6e5c058 refcnt:-1
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffa06ce6e5c058
PGD 190a01067 P4D 190a01067 PUD 43fffb067 PMD 22e403063 PTE 8000000226e5c063
Oops: 0011 [#1] SMP PTI
CPU: 7 PID: 7823 Comm: kworker/7:0 Kdump: loaded Tainted: G            E
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.2.1 04/01/2014
Call Trace:
 ? skb_release_head_state+0x68/0x100
 ? skb_release_all+0xe/0x30
 ? kfree_skb+0x32/0xa0
 ? mptcp_sendmsg_frag+0x57e/0x750
 ? __mptcp_retrans+0x21b/0x3c0
 ? __switch_to_asm+0x35/0x70
 ? mptcp_worker+0x25e/0x320
 ? process_one_work+0x1a7/0x360
 ? worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 ? kthread+0x112/0x130
 ? kthread_flush_work_fn+0x10/0x10
 ? ret_from_fork+0x35/0x40
===========================================================================

In __mptcp_alloc_tx_skb skb was allocated and skb->tcp_tsorted_anchor will
be initialized, in under memory pressure situation sk_wmem_schedule will
return false and then kfree_skb. In this case skb->_skb_refdst is not null
because_skb_refdst and tcp_tsorted_anchor are stored in the same mem, and
kfree_skb will try to release dst and cause crash.

Fixes: f70cad1085d1 ("mptcp: stop relying on tcp_tx_skb_cache")
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Link: https://lore.kernel.org/r/20220317220953.426024-1-mathew.j.martineau@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1246,6 +1246,7 @@ static struct sk_buff *__mptcp_alloc_tx_
 		tcp_skb_entail(ssk, skb);
 		return skb;
 	}
+	tcp_skb_tsorted_anchor_cleanup(skb);
 	kfree_skb(skb);
 	return NULL;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28A04D49E8
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbiCJOVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244620AbiCJOTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:19:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754E517775B;
        Thu, 10 Mar 2022 06:16:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2474B825A7;
        Thu, 10 Mar 2022 14:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3C3C340E8;
        Thu, 10 Mar 2022 14:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921727;
        bh=xEM7bM1MS3ZnvwOhutZQEBGhLFXWiu3krUw3+5mpfAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ9W5+bn0p7yck8GMsz0pgg1KWz1zylVgFPVP3nQDw1XZMvRpJyB+wdRHcidjlRcE
         BRzSQCkKblQ1GYrwlXJHuuJkuDKrbB3loZqZhYm34Nx5bqtAtgV4HyH6oWwQK6Wh3d
         n8sGWz9QJTqTMA0txgf8eUW0Ffp1YceujFIo3UdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.9 34/38] xen/scsifront: dont use gnttab_query_foreign_access() for mapped status
Date:   Thu, 10 Mar 2022 15:13:47 +0100
Message-Id: <20220310140809.129519975@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit 33172ab50a53578a95691310f49567c9266968b0 upstream.

It isn't enough to check whether a grant is still being in use by
calling gnttab_query_foreign_access(), as a mapping could be realized
by the other side just after having called that function.

In case the call was done in preparation of revoking a grant it is
better to do so via gnttab_try_end_foreign_access() and check the
success of that operation instead.

This is CVE-2022-23038 / part of XSA-396.

Reported-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/xen-scsifront.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -210,12 +210,11 @@ static void scsifront_gnttab_done(struct
 		return;
 
 	for (i = 0; i < s->nr_grants; i++) {
-		if (unlikely(gnttab_query_foreign_access(s->gref[i]) != 0)) {
+		if (unlikely(!gnttab_try_end_foreign_access(s->gref[i]))) {
 			shost_printk(KERN_ALERT, info->host, KBUILD_MODNAME
 				     "grant still in use by backend\n");
 			BUG();
 		}
-		gnttab_end_foreign_access(s->gref[i], 0, 0UL);
 	}
 
 	kfree(s->sg);



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2074F2554
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiDEHtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiDEHrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA429AE4B;
        Tue,  5 Apr 2022 00:42:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CCA56CE1BDB;
        Tue,  5 Apr 2022 07:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45DDC34110;
        Tue,  5 Apr 2022 07:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144576;
        bh=FTdr9P169BdkCBRchSv5Z3/8Y8m9sOPzKMm0EvuZZRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/rd3mo3lX7/Ymj+J/+2c0YhheSlREXisrK49+ZMAJHgq+MyfHe2U1VO5z0MTpXSJ
         bNOFgpQem5h313zsBd7FWaxm4apQ2Wir3+N7rr9Rha7rExYqUgKOdKQ+7fnXAFSgu0
         i09Hrxcea04RHEVlMl0sNvYAI/bS+epC0TFAr7ig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 0093/1126] cifs: fix incorrect use of list iterator after the loop
Date:   Tue,  5 Apr 2022 09:14:00 +0200
Message-Id: <20220405070410.297721725@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit a96c94481f5993eac2271f9fb4d009b7dc076c24 upstream.

The bug is here:
if (!tcon) {
	resched = true;
	list_del_init(&ses->rlist);
	cifs_put_smb_ses(ses);

Because the list_for_each_entry() never exits early (without any
break/goto/return inside the loop), the iterator 'ses' after the
loop will always be an pointer to a invalid struct containing the
HEAD (&pserver->smb_ses_list). As a result, the uses of 'ses' above
will lead to a invalid memory access.

The original intention should have been to walk each entry 'ses' in
'&tmp_ses_list', delete '&ses->rlist' and put 'ses'. So fix it with
a list_for_each_entry_safe().

Cc: stable@vger.kernel.org # 5.17
Fixes: 3663c9045f51a ("cifs: check reconnects for channels of active tcons too")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3858,8 +3858,10 @@ void smb2_reconnect_server(struct work_s
 	tcon = kzalloc(sizeof(struct cifs_tcon), GFP_KERNEL);
 	if (!tcon) {
 		resched = true;
-		list_del_init(&ses->rlist);
-		cifs_put_smb_ses(ses);
+		list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
+			list_del_init(&ses->rlist);
+			cifs_put_smb_ses(ses);
+		}
 		goto done;
 	}
 



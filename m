Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5D594601
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345165AbiHOWTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349701AbiHOWRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AF72ED45;
        Mon, 15 Aug 2022 12:40:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9396BB80EA7;
        Mon, 15 Aug 2022 19:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F88C433D6;
        Mon, 15 Aug 2022 19:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592432;
        bh=bqOWLUEtmJFZwXCw3UqJncyrYlm7mOE2OSE/xVhMHtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AiH8L0QXOvEPntkqhh4HoF/MfDCPIk+OZWuk0usW19B7DOI+QUuD4KAwSXnPrDZYA
         gpAjzWHFOu+eY4qc2njYzzH09BMYB1eS7/qXXoNEIWViu8dUgYtigKlwpO4L0aHRW0
         0z2DVPW73JBOTfSRpCPeIMiuNvrmbMg5QAVVe754=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.19 0109/1157] ksmbd: prevent out of bound read for SMB2_TREE_CONNNECT
Date:   Mon, 15 Aug 2022 19:51:05 +0200
Message-Id: <20220815180444.002157494@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 824d4f64c20093275f72fc8101394d75ff6a249e upstream.

if Status is not 0 and PathLength is long,
smb_strndup_from_utf16 could make out of bound
read in smb2_tree_connnect.

This bug can lead an oops looking something like:

[ 1553.882047] BUG: KASAN: slab-out-of-bounds in smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882064] Read of size 2 at addr ffff88802c4eda04 by task kworker/0:2/42805
...
[ 1553.882095] Call Trace:
[ 1553.882098]  <TASK>
[ 1553.882101]  dump_stack_lvl+0x49/0x5f
[ 1553.882107]  print_report.cold+0x5e/0x5cf
[ 1553.882112]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882122]  kasan_report+0xaa/0x120
[ 1553.882128]  ? smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882139]  __asan_report_load_n_noabort+0xf/0x20
[ 1553.882143]  smb_strndup_from_utf16+0x469/0x4c0 [ksmbd]
[ 1553.882155]  ? smb_strtoUTF16+0x3b0/0x3b0 [ksmbd]
[ 1553.882166]  ? __kmalloc_node+0x185/0x430
[ 1553.882171]  smb2_tree_connect+0x140/0xab0 [ksmbd]
[ 1553.882185]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1553.882197]  process_one_work+0x778/0x11c0
[ 1553.882201]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1553.882206]  worker_thread+0x544/0x1180
[ 1553.882209]  ? __cpuidle_text_end+0x4/0x4
[ 1553.882214]  kthread+0x282/0x320
[ 1553.882218]  ? process_one_work+0x11c0/0x11c0
[ 1553.882221]  ? kthread_complete_and_exit+0x30/0x30
[ 1553.882225]  ret_from_fork+0x1f/0x30
[ 1553.882231]  </TASK>

There is no need to check error request validation in server.
This check allow invalid requests not to validate message.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17818
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -90,11 +90,6 @@ static int smb2_get_data_area_len(unsign
 	*off = 0;
 	*len = 0;
 
-	/* error reqeusts do not have data area */
-	if (hdr->Status && hdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
-	    (((struct smb2_err_rsp *)hdr)->StructureSize) == SMB2_ERROR_STRUCTURE_SIZE2_LE)
-		return ret;
-
 	/*
 	 * Following commands have data areas so we have to get the location
 	 * of the data buffer offset and data buffer length for the particular



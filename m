Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C013D593558
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241079AbiHOSXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbiHOSW2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:22:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23552D1DC;
        Mon, 15 Aug 2022 11:17:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7227BB8107D;
        Mon, 15 Aug 2022 18:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17CCC433D6;
        Mon, 15 Aug 2022 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587434;
        bh=y8D86iaIAcMgG4Ko5STDm+qPGW86hj1iLyKTt2iRk+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p1fGUEJaYagkMPtWHkytfcj7czoqgMxCDxWxK4W+nz1Wyqjbk03DXD1NMj7pN1p3b
         89llB0UV9iZNAjc91O290u/dnX0syqmLJUI3RLfZlQe3x8X9USR8bLsrqGjkcCNJ6w
         VI2rHniYIUomIH91TIcWCjq2pBRzcDVPl1wrR16Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.15 084/779] ksmbd: fix use-after-free bug in smb2_tree_disconect
Date:   Mon, 15 Aug 2022 19:55:28 +0200
Message-Id: <20220815180340.880995784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit cf6531d98190fa2cf92a6d8bbc8af0a4740a223c upstream.

smb2_tree_disconnect() freed the struct ksmbd_tree_connect,
but it left the dangling pointer. It can be accessed
again under compound requests.

This bug can lead an oops looking something link:

[ 1685.468014 ] BUG: KASAN: use-after-free in ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468068 ] Read of size 4 at addr ffff888102172180 by task kworker/1:2/4807
...
[ 1685.468130 ] Call Trace:
[ 1685.468132 ]  <TASK>
[ 1685.468135 ]  dump_stack_lvl+0x49/0x5f
[ 1685.468141 ]  print_report.cold+0x5e/0x5cf
[ 1685.468145 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468157 ]  kasan_report+0xaa/0x120
[ 1685.468194 ]  ? ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468206 ]  __asan_report_load4_noabort+0x14/0x20
[ 1685.468210 ]  ksmbd_tree_conn_disconnect+0x131/0x160 [ksmbd]
[ 1685.468222 ]  smb2_tree_disconnect+0x175/0x250 [ksmbd]
[ 1685.468235 ]  handle_ksmbd_work+0x30e/0x1020 [ksmbd]
[ 1685.468247 ]  process_one_work+0x778/0x11c0
[ 1685.468251 ]  ? _raw_spin_lock_irq+0x8e/0xe0
[ 1685.468289 ]  worker_thread+0x544/0x1180
[ 1685.468293 ]  ? __cpuidle_text_end+0x4/0x4
[ 1685.468297 ]  kthread+0x282/0x320
[ 1685.468301 ]  ? process_one_work+0x11c0/0x11c0
[ 1685.468305 ]  ? kthread_complete_and_exit+0x30/0x30
[ 1685.468309 ]  ret_from_fork+0x1f/0x30

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17816
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2044,6 +2044,7 @@ int smb2_tree_disconnect(struct ksmbd_wo
 
 	ksmbd_close_tree_conn_fds(work);
 	ksmbd_tree_conn_disconnect(sess, tcon);
+	work->tcon = NULL;
 	return 0;
 }
 



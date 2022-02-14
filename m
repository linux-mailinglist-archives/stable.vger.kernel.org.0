Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8919B4B4BCD
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346309AbiBNKSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:18:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346669AbiBNKP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:15:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101FD7922D;
        Mon, 14 Feb 2022 01:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55348B80D6D;
        Mon, 14 Feb 2022 09:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DAEC340E9;
        Mon, 14 Feb 2022 09:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832377;
        bh=8ub30ShdTLXwZFcoIMXYvvWBHyjJegmarl+2ns4BQYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRnGcDfLI5ZEGSjrDy2JUKs60apQTebBDzfaiHwE/opfnDSxPymF+CIKV0jY6OvPq
         c/vMTm9dSFQU/rlMSrZF7A5MRN+IaDB6xkyiQKSNcYzj4cDdiyeB7GFsn6V6J/raA1
         aAqsj021TNF+OPmMy1XNR2KGSwqfFQIcmQdFT+W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Jakob Koschel <jakobkoschel@gmail.com>
Subject: [PATCH 5.15 135/172] vt_ioctl: add array_index_nospec to VT_ACTIVATE
Date:   Mon, 14 Feb 2022 10:26:33 +0100
Message-Id: <20220214092511.069185634@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Koschel <jakobkoschel@gmail.com>

commit 28cb138f559f8c1a1395f5564f86b8bbee83631b upstream.

in vt_setactivate an almost identical code path has been patched
with array_index_nospec. In the VT_ACTIVATE path the user input
is from a system call argument instead of a usercopy.
For consistency both code paths should have the same mitigations
applied.

Kasper Acknowledgements: Jakob Koschel, Brian Johannesmeyer, Kaveh
Razavi, Herbert Bos, Cristiano Giuffrida from the VUSec group at VU
Amsterdam.

Co-developed-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20220127144406.3589293-2-jakobkoschel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -845,6 +845,7 @@ int vt_ioctl(struct tty_struct *tty,
 			return -ENXIO;
 
 		arg--;
+		arg = array_index_nospec(arg, MAX_NR_CONSOLES);
 		console_lock();
 		ret = vc_allocate(arg);
 		console_unlock();



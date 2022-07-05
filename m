Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D59566E12
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237341AbiGEMbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiGEMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324D6DE;
        Tue,  5 Jul 2022 05:18:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E269BB816A4;
        Tue,  5 Jul 2022 12:18:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5691EC341C7;
        Tue,  5 Jul 2022 12:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023496;
        bh=iFzlqXbDqvDXj3pGPGtn3Sba10HjY8FU59MvO3aWhm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0V7Jc1fIGHLoW4aCPe6FgAt9iYPayvJWkRhkcCzw2Xs2MaMuANbHshXK7U3lgEbd
         rOo5LhSOnWDJb3D/+cJauVY4UXcE6UsTERGGAe5Lb0szX8PeruGYfzQRnAejOaNzQ0
         doRML9tI8nclLLPGfh1uTRJQHczxr43wxN2nFnoc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ossama Othman <ossama.othman@intel.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 040/102] mptcp: fix conflict with <netinet/in.h>
Date:   Tue,  5 Jul 2022 13:58:06 +0200
Message-Id: <20220705115619.549502710@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ossama Othman <ossama.othman@intel.com>

commit 06e445f740c1a0fe5d16b3dff8a4ef18e124e54e upstream.

Including <linux/mptcp.h> before the C library <netinet/in.h> header
causes symbol redefinition errors at compile-time due to duplicate
declarations and definitions in the <linux/in.h> header included by
<linux/mptcp.h>.

Explicitly include <netinet/in.h> before <linux/in.h> in
<linux/mptcp.h> when __KERNEL__ is not defined so that the C library
compatibility logic in <linux/libc-compat.h> is enabled when including
<linux/mptcp.h> in user space code.

Fixes: c11c5906bc0a ("mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support")
Signed-off-by: Ossama Othman <ossama.othman@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/mptcp.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index 921963589904..dfe19bf13f4c 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -2,16 +2,17 @@
 #ifndef _UAPI_MPTCP_H
 #define _UAPI_MPTCP_H
 
+#ifndef __KERNEL__
+#include <netinet/in.h>		/* for sockaddr_in and sockaddr_in6	*/
+#include <sys/socket.h>		/* for struct sockaddr			*/
+#endif
+
 #include <linux/const.h>
 #include <linux/types.h>
 #include <linux/in.h>		/* for sockaddr_in			*/
 #include <linux/in6.h>		/* for sockaddr_in6			*/
 #include <linux/socket.h>	/* for sockaddr_storage and sa_family	*/
 
-#ifndef __KERNEL__
-#include <sys/socket.h>		/* for struct sockaddr			*/
-#endif
-
 #define MPTCP_SUBFLOW_FLAG_MCAP_REM		_BITUL(0)
 #define MPTCP_SUBFLOW_FLAG_MCAP_LOC		_BITUL(1)
 #define MPTCP_SUBFLOW_FLAG_JOIN_REM		_BITUL(2)
-- 
2.37.0




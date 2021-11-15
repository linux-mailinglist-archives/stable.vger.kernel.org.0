Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DBA450CEC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238255AbhKORq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238639AbhKORnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:43:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5247632F5;
        Mon, 15 Nov 2021 17:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997310;
        bh=SbuKvyUjnzr2t6us1hKrFAz3S84DcHuGAFr+Bu2n18g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulorxn+bNXsIFZhky4wH5ybWOJqO2zsnWbkRlPVqwC6bnl94YTol6/BLfOxr/WQkP
         VdsZg5pcbEsVt0+Fn+JYmWcV8HNpmKUX4zMnD90jSCkMaA+6NoF9TS03yPZEB2YGvS
         JiLtD3DlpVrokSuK3M04yOA5VXDwiBmUs3HImDLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.10 101/575] evm: mark evm_fixmode as __ro_after_init
Date:   Mon, 15 Nov 2021 17:57:06 +0100
Message-Id: <20211115165347.152538610@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Austin Kim <austin.kim@lge.com>

commit 32ba540f3c2a7ef61ed5a577ce25069a3d714fc9 upstream.

The evm_fixmode is only configurable by command-line option and it is never
modified outside initcalls, so declaring it with __ro_after_init is better.

Signed-off-by: Austin Kim <austin.kim@lge.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/evm/evm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -54,7 +54,7 @@ static struct xattr_list evm_config_defa
 
 LIST_HEAD(evm_config_xattrnames);
 
-static int evm_fixmode;
+static int evm_fixmode __ro_after_init;
 static int __init evm_set_fixmode(char *str)
 {
 	if (strncmp(str, "fix", 3) == 0)



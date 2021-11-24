Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB5645BAD7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbhKXMOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243429AbhKXMOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8F2860E0B;
        Wed, 24 Nov 2021 12:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755731;
        bh=eWp0zbdjR3a6Xli6vv2vWnDX+W6t+x220awK9JqbbWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVnkFYtdY/fo+0KVwaoUXsGyPI8WogV9PCPRX0j8Y/m0Yqj13N7a2eWqN1YYwtGqE
         diy4kz8w77cfngFZTPdY5NZHWE7JulT7FdfvwfansMHnx1yRFFWEoCQOSdKqvK8ipO
         XOmaot5EvRuu662Mf0BGRPX04BXXg13FKHu0p1Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.9 037/207] evm: mark evm_fixmode as __ro_after_init
Date:   Wed, 24 Nov 2021 12:55:08 +0100
Message-Id: <20211124115705.144354209@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -54,7 +54,7 @@ char *evm_config_xattrnames[] = {
 	NULL
 };
 
-static int evm_fixmode;
+static int evm_fixmode __ro_after_init;
 static int __init evm_set_fixmode(char *str)
 {
 	if (strncmp(str, "fix", 3) == 0)



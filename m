Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9817F45BF8E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345460AbhKXM7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:59:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345796AbhKXM5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:57:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD40617E5;
        Wed, 24 Nov 2021 12:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757186;
        bh=KKjPAI1lVlnPQVWx+EIyhzuCjSs0hL4ftHrfCQaq6lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhjVSyHEUIuN+wNcdT2eQ3WXoWqMdY/o1dlMzPOxTOyur3Btg4pJTtiR0IoBuhGNt
         yR6ww+PzQqrLYlq92IDevUwRjMByBtpXBEPpYCxdHfypni5ThjNL7gkNRQhjtNdeaz
         6hO4HdB4GpQqPRClOuABC+n8VDzU2XZQbj3/4Rdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Austin Kim <austin.kim@lge.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 4.19 053/323] evm: mark evm_fixmode as __ro_after_init
Date:   Wed, 24 Nov 2021 12:54:03 +0100
Message-Id: <20211124115720.661812468@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -59,7 +59,7 @@ static struct xattr_list evm_config_defa
 
 LIST_HEAD(evm_config_xattrnames);
 
-static int evm_fixmode;
+static int evm_fixmode __ro_after_init;
 static int __init evm_set_fixmode(char *str)
 {
 	if (strncmp(str, "fix", 3) == 0)



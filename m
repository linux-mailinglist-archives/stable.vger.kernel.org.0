Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C65EA157958
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgBJNOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:14:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729147AbgBJMic (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:32 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00C4F20842;
        Mon, 10 Feb 2020 12:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338312;
        bh=xPjFRomVxdpO+HM2q+A9172l/tUjWzy5wahhYlj59YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SE6AOFVnb9ClD7tuM7/+Wwn+s+sB2lzVxezaU3+Ar8R4+Na4qnjpCv8/cy/VgNcWu
         hh8Gs8DUCrvgB+Vl4aqPWn8hpFppbPrgv78xDAYvUaJiJ77mIAjdQBZMc6Zovmk5mq
         DgtYOQtWNPRzNqjPWAMSU/fkTAeB/Rn4FMoceeh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 5.4 236/309] percpu: Separate decrypted varaibles anytime encryption can be enabled
Date:   Mon, 10 Feb 2020 04:33:12 -0800
Message-Id: <20200210122429.193975577@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erdem Aktas <erdemaktas@google.com>

commit 264b0d2bee148073c117e7bbbde5be7125a53be1 upstream.

CONFIG_VIRTUALIZATION may not be enabled for memory encrypted guests.  If
disabled, decrypted per-CPU variables may end up sharing the same page
with variables that should be left encrypted.

Always separate per-CPU variables that should be decrypted into their own
page anytime memory encryption can be enabled in the guest rather than
rely on any other config option that may not be enabled.

Fixes: ac26963a1175 ("percpu: Introduce DEFINE_PER_CPU_DECRYPTED")
Cc: stable@vger.kernel.org # 4.15+
Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/percpu-defs.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -175,8 +175,7 @@
  * Declaration/definition used for per-CPU variables that should be accessed
  * as decrypted when memory encryption is enabled in the guest.
  */
-#if defined(CONFIG_VIRTUALIZATION) && defined(CONFIG_AMD_MEM_ENCRYPT)
-
+#ifdef CONFIG_AMD_MEM_ENCRYPT
 #define DECLARE_PER_CPU_DECRYPTED(type, name)				\
 	DECLARE_PER_CPU_SECTION(type, name, "..decrypted")
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1B11B5B8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731796AbfLKPzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730329AbfLKPQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:16:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A484208C3;
        Wed, 11 Dec 2019 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077409;
        bh=Kxa5WyMgQit6kjaJNFOCMh1jYPWLabPyHMg/gJX4mmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gm5KqiyM5lw4zfD/o0azoFnXFVMWvQeWGyrlvHX8x8XaidnW2o9Ntd7qNSR2AuWdZ
         oirSiAOH+c1BeRzVoebgKs4//PLLCnbQGQJfI7qdnEdXBIurfEQDJpIeO10ieaoxJI
         8KztWUxes8akT0FPlLlTQo4LiQg3sJwHXU6WnsWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4.19 004/243] lp: fix sparc64 LPSETTIMEOUT ioctl
Date:   Wed, 11 Dec 2019 16:02:46 +0100
Message-Id: <20191211150339.449307512@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 45a2d64696b11913bcf1087b041740edbade3e21 upstream.

The layout of struct timeval is different on sparc64 from
anything else, and the patch I did long ago failed to take
this into account.

Change it now to handle sparc64 user space correctly again.

Quite likely nobody cares about parallel ports on sparc64,
but there is no reason not to fix it.

Cc: stable@vger.kernel.org
Fixes: 9a450484089d ("lp: support 64-bit time_t user space")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20191108203435.112759-7-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/lp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -708,6 +708,10 @@ static int lp_set_timeout64(unsigned int
 	if (copy_from_user(karg, arg, sizeof(karg)))
 		return -EFAULT;
 
+	/* sparc64 suseconds_t is 32-bit only */
+	if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
+		karg[1] >>= 32;
+
 	return lp_set_timeout(minor, karg[0], karg[1]);
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870A71F2CC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfEOMHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 08:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727932AbfEOLJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:09:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38FB92084F;
        Wed, 15 May 2019 11:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918555;
        bh=KjgevnIayluyYbD7E71m24a0YTAYDPL763Wo13fyqIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2XKnBpkqKH3H9sTIIY0sM2MTxWxwnZi+PxnLk45EBg++5zXsM6TCjnryj/Ln/6H+Y
         8TrDiK3m3GYyFYUq5zFsk87PmvOB17lQ1Rz7lHnXOhS1c64AVreNaDEa1vD83ElJa2
         GK94xYEwVBL2Bp17bSJ0eSDKGl1bvFDxiPhzGMR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 178/266] locking/static_keys: Provide DECLARE and well as DEFINE macros
Date:   Wed, 15 May 2019 12:54:45 +0200
Message-Id: <20190515090728.946363692@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

commit b8fb03785d4de097507d0cf45873525e0ac4d2b2 upstream.

We will need to provide declarations of static keys in header
files. Provide DECLARE_STATIC_KEY_{TRUE,FALSE} macros.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/816881cf85bd3cf13385d212882618f38a3b5d33.1472754711.git.tony.luck@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/jump_label.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -267,9 +267,15 @@ struct static_key_false {
 #define DEFINE_STATIC_KEY_TRUE(name)	\
 	struct static_key_true name = STATIC_KEY_TRUE_INIT
 
+#define DECLARE_STATIC_KEY_TRUE(name)	\
+	extern struct static_key_true name
+
 #define DEFINE_STATIC_KEY_FALSE(name)	\
 	struct static_key_false name = STATIC_KEY_FALSE_INIT
 
+#define DECLARE_STATIC_KEY_FALSE(name)	\
+	extern struct static_key_false name
+
 extern bool ____wrong_branch_error(void);
 
 #define static_key_enabled(x)							\



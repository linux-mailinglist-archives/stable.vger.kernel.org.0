Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DE6431ABC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhJRN3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231310AbhJRN16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F20F16103D;
        Mon, 18 Oct 2021 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563547;
        bh=rvsvVO5Xy1rsi14PHe8eAjf9UGx0G65KJ+aNPwgGFNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfj0tmWgXL0p15VeTqAyN9AgHSuurvqsXmobjrqhT2sYYXOKHMyEBJfG/9l+2go46
         FgPPyWcsWQMC6n6EFtpQ1Ga7qRQNipSCrVq8f0+C+iiKACsTt7iAWH2G2jPsSr2GcG
         Y/+NDWjmrWfcU766qR0dExnQjmxsVdAxkJg5XP24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/39] stable: clamp SUBLEVEL in 4.14
Date:   Mon, 18 Oct 2021 15:24:10 +0200
Message-Id: <20211018132325.476752539@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org>

Right now SUBLEVEL is overflowing, and some userspace may start treating
4.14.256 as 4.15. While out of tree modules have different ways of
extracting the version number (and we're generally ok with breaking
them), we do care about breaking userspace and it would appear that this
overflow might do just that.

Our rules around userspace ABI in the stable kernel are pretty simple:
we don't break it. Thus, while userspace may be checking major/minor, it
shouldn't be doing anything with sublevel.

This patch applies a big band-aid to the 4.14 kernel in the form of
clamping the sublevel to 255.

The clamp is done for the purpose of LINUX_VERSION_CODE only, and
extracting the version number from the Makefile or "make kernelversion"
will continue to work as intended.

We might need to do it later in newer trees, but maybe we'll have a
better solution by then, so I'm ignoring that problem for now.

Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1162,7 +1162,7 @@ endef
 
 define filechk_version.h
 	(echo \#define LINUX_VERSION_CODE $(shell                         \
-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255); \
 	echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';)
 endef
 



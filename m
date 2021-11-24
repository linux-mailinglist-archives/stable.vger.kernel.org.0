Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED145C5F4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349572AbhKXODE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350650AbhKXOA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B640632F7;
        Wed, 24 Nov 2021 13:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759385;
        bh=ma3+/MsV3dPimc2kWHKUSKOiOxAkRuw68gL41V3FpRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dxG+sB4/Mi1Xzb7qI/Lw9pXSF+CVQtAk2Arul8MTdAiVEWNdjTMfVySwL644/bzZE
         OO4qV4qH8G7X9pXc5Zo6p3HtspuiBttdft/6c/KKY0GwCNNITYGHrDl+aERTvolSMh
         iYR68y1XohbD8Ub6YDrlSfqISamX+Va9vhBN+i+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Delva <adelva@google.com>,
        Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>, Jens Axboe <axboe@kernel.dk>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 5.15 222/279] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
Date:   Wed, 24 Nov 2021 12:58:29 +0100
Message-Id: <20211124115726.409329172@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Delva <adelva@google.com>

commit 94c4b4fd25e6c3763941bdec3ad54f2204afa992 upstream.

Booting to Android userspace on 5.14 or newer triggers the following
SELinux denial:

avc: denied { sys_nice } for comm="init" capability=23
     scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
     permissive=0

Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
better compatibility with older SEPolicy, check ADMIN before NICE.

Fixes: 9d3a39a5f1e4 ("block: grant IOPRIO_CLASS_RT to CAP_SYS_NICE")
Signed-off-by: Alistair Delva <adelva@google.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: selinux@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org # v5.14+
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Link: https://lore.kernel.org/r/20211115181655.3608659-1-adelva@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioprio.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/block/ioprio.c
+++ b/block/ioprio.c
@@ -69,7 +69,14 @@ int ioprio_check_cap(int ioprio)
 
 	switch (class) {
 		case IOPRIO_CLASS_RT:
-			if (!capable(CAP_SYS_NICE) && !capable(CAP_SYS_ADMIN))
+			/*
+			 * Originally this only checked for CAP_SYS_ADMIN,
+			 * which was implicitly allowed for pid 0 by security
+			 * modules such as SELinux. Make sure we check
+			 * CAP_SYS_ADMIN first to avoid a denial/avc for
+			 * possibly missing CAP_SYS_NICE permission.
+			 */
+			if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
 				return -EPERM;
 			fallthrough;
 			/* rt has prio field too */



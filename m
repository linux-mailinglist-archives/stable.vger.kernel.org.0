Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5F26F376
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgIRDHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbgIRCEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A1D23731;
        Fri, 18 Sep 2020 02:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394634;
        bh=jmvDnSEOax1Tuvm1Xg+Dd7FydMJu2H7x39Iy9foNVzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKLd1PBiIROmX5g9x1zh5Ti1AKvDEzbylllsoWWBw6mrwkhtwLplPWquMeG8wzx/R
         kcYa7AsZRuvsXrtQlj/gSdZdTMkZUtmY4yBnIzTbC8Y+aNxpc6610YbJ3dCSb35vpU
         g42vCI0ilsmU6QSNwafnvnkcWgVBsQFeANAvcbhE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 134/330] KVM: x86: fix incorrect comparison in trace event
Date:   Thu, 17 Sep 2020 21:57:54 -0400
Message-Id: <20200918020110.2063155-134-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 147f1a1fe5d7e6b01b8df4d0cbd6f9eaf6b6c73b ]

The "u" field in the event has three states, -1/0/1.  Using u8 however means that
comparison with -1 will always fail, so change to signed char.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmutrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3c6522b84ff11..ffcd96fc02d0a 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -339,7 +339,7 @@ TRACE_EVENT(
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
 		__field(bool, x)
-		__field(u8, u)
+		__field(signed char, u)
 	),
 
 	TP_fast_assign(
-- 
2.25.1


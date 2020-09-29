Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7719C27C904
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731559AbgI2MGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgI2Lhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94A0023A6C;
        Tue, 29 Sep 2020 11:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379428;
        bh=jmvDnSEOax1Tuvm1Xg+Dd7FydMJu2H7x39Iy9foNVzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vlGztNHfAd8ceJHy8psxPORimF4ynHE4aCOGh9RrbB+e9bDuNwzo4V9OB5dxbGJIV
         1ALYBpiskOBNDA09isOT/4P1h6tmkq/YzqMauqTk8tVWo8p9wAYd0xBPeqxIEPAW5X
         7b2cxYj4EcaYtrC3QV8x4h73bHqm7tEuJhLvy/Eo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/388] KVM: x86: fix incorrect comparison in trace event
Date:   Tue, 29 Sep 2020 12:57:39 +0200
Message-Id: <20200929110016.664744011@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




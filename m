Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B8027C517
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgI2Lag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgI2L3X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13A7423A60;
        Tue, 29 Sep 2020 11:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378633;
        bh=dQPUNc8vecNZt/Q9TRKBDUuZu+b6RB2o+cXiNyBIscY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5hi8IYVj0y4tTFfLQ4HFNh+9ABxazoqme644OFlWcrIXTHYyGlsaprnjqiMJfyVP
         eDj1633AK4N0WsGIB4vdSrAiLRPvr1/6Utmhvwh65k+MoO1MBIJKPHpGvVy7wmdLzf
         wQSnARsS0Hci520boGPtHRHs1Zu1Y9rWzdm2VJig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/245] KVM: x86: fix incorrect comparison in trace event
Date:   Tue, 29 Sep 2020 12:58:55 +0200
Message-Id: <20200929105951.083894238@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index cb41b036eb264..7e0dc8c7da2c0 100644
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




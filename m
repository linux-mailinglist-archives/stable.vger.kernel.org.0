Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D929927C3D7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgI2LJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729051AbgI2LJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C467F21D46;
        Tue, 29 Sep 2020 11:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377749;
        bh=tZIA5kCi1OJs2CUyW7GZi810eovjNZzjiYFeAE6RF00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJFW2OAVB139Kcq/pplUgvB+9b8F4nfr3OCVdUsncODg7zsIpgjH4sJtd/kq5YPY0
         3sTooNK/Rd7wfvipjxpOjITcGY2Z3MNqSoExPIOrxMd0yVpiYcx5F+tixfnk6f6D3M
         T7BRYAvHtPLuEYrdTcTX6t7Pdarzv4jfFXQepwSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/121] KVM: x86: fix incorrect comparison in trace event
Date:   Tue, 29 Sep 2020 12:59:55 +0200
Message-Id: <20200929105932.724806676@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
index 756b14ecc957a..df1076b0eabf3 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -336,7 +336,7 @@ TRACE_EVENT(
 		/* These depend on page entry type, so compute them now.  */
 		__field(bool, r)
 		__field(bool, x)
-		__field(u8, u)
+		__field(signed char, u)
 	),
 
 	TP_fast_assign(
-- 
2.25.1




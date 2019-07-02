Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169285CB3E
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfGBIIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728456AbfGBIIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:08:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3132184C;
        Tue,  2 Jul 2019 08:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054914;
        bh=emvwUdVW0+nZbV6MltQoEQlRpt9QAeRJY2O4pV29Klw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUWmo5WZlxN5laMKAJhO7df4PxKMDv6AJHxFjbelBhJ/1QU+UOJOdDCDXBMYjCIAR
         em3JwSJ8VXKCbQDqT7tbi1Pi5xktKu0Veg6GfeaJqDR/lGICjeRfuT/x7KFJG00w18
         CVNRCIWpB+B3cfYnVr7iW1h6ZTB1PoE4x4jECNXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.19 68/72] arm64: futex: Avoid copying out uninitialised stack in failed cmpxchg()
Date:   Tue,  2 Jul 2019 10:02:09 +0200
Message-Id: <20190702080128.167642047@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 8e4e0ac02b449297b86498ac24db5786ddd9f647 upstream.

Returning an error code from futex_atomic_cmpxchg_inatomic() indicates
that the caller should not make any use of *uval, and should instead act
upon on the value of the error code. Although this is implemented
correctly in our futex code, we needlessly copy uninitialised stack to
*uval in the error case, which can easily be avoided.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/futex.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/futex.h
+++ b/arch/arm64/include/asm/futex.h
@@ -134,7 +134,9 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 	: "memory");
 	uaccess_disable();
 
-	*uval = val;
+	if (!ret)
+		*uval = val;
+
 	return ret;
 }
 



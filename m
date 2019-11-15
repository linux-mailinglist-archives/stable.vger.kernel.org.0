Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90784FD655
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKOGVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:50422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfKOGVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:33 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5155B20732;
        Fri, 15 Nov 2019 06:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798892;
        bh=R/yEUO+q2waTOvNlrvQlDw37xD7IuqRvVUN46oEIu2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9dfC5DJ7MwRQDZZBbroOJqEqXenEYzbeD0N+e/lufCrrrkAGLkSNo2d9zhXfAvX/
         Nbd96WLa8+kpxhUQIJzvNBKg3HTX49+zDPrQu3+rBZjOMiga9cHG+bsANLI++IiiGY
         +y3P2CUyhLYTY4zK/kj8d+Tt87+wUJWuysCmoFtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonas Gorski <jonas.gorski@gmail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 4.4 02/20] MIPS: BCM63XX: fix switch core reset on BCM6368
Date:   Fri, 15 Nov 2019 14:20:31 +0800
Message-Id: <20191115062008.088360533@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 8a38dacf87180738d42b058334c951eba15d2d47 upstream.

The Ethernet Switch core mask was set to 0, causing the switch core to
be not reset on BCM6368 on boot. Provide the proper mask so the switch
core gets reset to a known good state.

Fixes: 799faa626c71 ("MIPS: BCM63XX: add core reset helper")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/bcm63xx/reset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/bcm63xx/reset.c
+++ b/arch/mips/bcm63xx/reset.c
@@ -119,7 +119,7 @@
 #define BCM6368_RESET_DSL	0
 #define BCM6368_RESET_SAR	SOFTRESET_6368_SAR_MASK
 #define BCM6368_RESET_EPHY	SOFTRESET_6368_EPHY_MASK
-#define BCM6368_RESET_ENETSW	0
+#define BCM6368_RESET_ENETSW	SOFTRESET_6368_ENETSW_MASK
 #define BCM6368_RESET_PCM	SOFTRESET_6368_PCM_MASK
 #define BCM6368_RESET_MPI	SOFTRESET_6368_MPI_MASK
 #define BCM6368_RESET_PCIE	0



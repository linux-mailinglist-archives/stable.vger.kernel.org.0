Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755F124F9D3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgHXIjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:39:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgHXIjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 336F82177B;
        Mon, 24 Aug 2020 08:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258381;
        bh=X1Jc6HRrlX3sT+03uEUsKl4ouu4xw5betJQxvtle9D8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkoLwT/zbNTDZDu1l7fIMLaJll9e8fCbHtRSwieePHADc9Xutfg6Jwq1vbp489/em
         ekC7ulkbyEdJZJsUlwAmFGVLC9rMh7ZqtKETBuuElyi5mz6Meb/g2u18ri4KInGMVF
         ekMvHjhXDQHdh4oU/bCCJKGA8mN+utM2BLUozSeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 027/124] drm/amd/display: fix pow() crashing when given base 0
Date:   Mon, 24 Aug 2020 10:29:21 +0200
Message-Id: <20200824082410.747521526@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krunoslav Kovac <Krunoslav.Kovac@amd.com>

commit d2e59d0ff4c44d1f6f8ed884a5bea7d1bb7fd98c upstream.

[Why&How]
pow(a,x) is implemented as exp(x*log(a)). log(0) will crash.
So return 0^x = 0, unless x=0, convention seems to be 0^0 = 1.

Cc: stable@vger.kernel.org
Signed-off-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/include/fixed31_32.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/include/fixed31_32.h
+++ b/drivers/gpu/drm/amd/display/include/fixed31_32.h
@@ -431,6 +431,9 @@ struct fixed31_32 dc_fixpt_log(struct fi
  */
 static inline struct fixed31_32 dc_fixpt_pow(struct fixed31_32 arg1, struct fixed31_32 arg2)
 {
+	if (arg1.value == 0)
+		return arg2.value == 0 ? dc_fixpt_one : dc_fixpt_zero;
+
 	return dc_fixpt_exp(
 		dc_fixpt_mul(
 			dc_fixpt_log(arg1),



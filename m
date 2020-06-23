Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C991520633C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbgFWUTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389833AbgFWUTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEF6C20EDD;
        Tue, 23 Jun 2020 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943580;
        bh=aAHP2yQ/zxHvxUsNP9s5qivNKq5cL42U1acJyxkcbQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqKukeUu8/EZSUvBMsw/Aj7RiGvjZhO9u8rOOmQq+DlM1zcKwP42RtHDaVkNp3xXX
         3z/huktj6Uo61FioYvl8jB1Ab+faICar/J26EGcMyuQXfJqikiC8dscS37vJF7KLKp
         Ae5B6xEUWWfQgt58delW/1PWQL1Gg+00pO3ufr1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.7 448/477] drm/amd/display: Use kvfree() to free coeff in build_regamma()
Date:   Tue, 23 Jun 2020 21:57:25 +0200
Message-Id: <20200623195428.712919208@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 81921a828b94ce2816932c19a5ec74d302972833 upstream.

Use kvfree() instead of kfree() to free coeff in build_regamma()
because the memory is allocated with kvzalloc().

Fixes: e752058b8671 ("drm/amd/display: Optimize gamma calculations")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -843,7 +843,7 @@ static bool build_regamma(struct pwl_flo
 	pow_buffer_ptr = -1; // reset back to no optimize
 	ret = true;
 release:
-	kfree(coeff);
+	kvfree(coeff);
 	return ret;
 }
 



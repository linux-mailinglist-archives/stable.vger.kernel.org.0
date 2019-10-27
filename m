Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0B8E68A1
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfJ0VSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:18:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbfJ0VR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:17:59 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D20521783;
        Sun, 27 Oct 2019 21:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211078;
        bh=dIhYXqC6zsENCqrC+i8wUr7eKSJQEN4dFD25TriTo3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xYhGSP44w0VeCqzyLfd7MeiCp8cCao2QideoMGG5+wST55IzcbYHjXPSMJWhzuI5+
         +HiBHIB/R3B1kSLcwjCw0ODeF+LzBgt9a8vgHr1G1diP6F7vuyURQmL5E0jak1TwTf
         kUjKZvgDOvZ6U0KqP7DXTXX5hcXDEnxfacXEwIp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "James Qian Wang (Arm Technology China)" <james.qian.wang@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 024/197] drm/komeda: prevent memory leak in komeda_wb_connector_add
Date:   Sun, 27 Oct 2019 21:59:02 +0100
Message-Id: <20191027203352.994952769@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit a0ecd6fdbf5d648123a7315c695fb6850d702835 ]

In komeda_wb_connector_add if drm_writeback_connector_init fails the
allocated memory for kwb_conn should be released.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Reviewed-by: James Qian Wang (Arm Technology China) <james.qian.wang@arm.com>
Signed-off-by: james qian wang (Arm Technology China) <james.qian.wang@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190925043031.32308-1-navid.emamdoost@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
index 23fbee268119f..b72840c06ab76 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_wb_connector.c
@@ -165,8 +165,10 @@ static int komeda_wb_connector_add(struct komeda_kms_dev *kms,
 					   &komeda_wb_encoder_helper_funcs,
 					   formats, n_formats);
 	komeda_put_fourcc_list(formats);
-	if (err)
+	if (err) {
+		kfree(kwb_conn);
 		return err;
+	}
 
 	drm_connector_helper_add(&wb_conn->base, &komeda_wb_conn_helper_funcs);
 
-- 
2.20.1




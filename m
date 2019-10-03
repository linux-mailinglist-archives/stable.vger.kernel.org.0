Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46540CABC9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730306AbfJCQAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731518AbfJCQAI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:00:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8092A207FF;
        Thu,  3 Oct 2019 16:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118408;
        bh=PISx2vyocSh8/A1YRwQdwLjLxS9DHcEQhiIdSzWqr9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S/h0sB49amCiM7oia0tDRlZR5SlExBo+Efw+j/nHPBo7wPmJiWAlMP7K6NVeur42j
         dYZBPru1VrrpktwDAwKht+P6+mHBzBdOyqHiGxzPU9kG/k+2D32Es1eMhlTsmGfbPi
         racA94M56dV9cegK1XOiMrfln2WvhqobgwAu+YwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 85/99] ASoC: Intel: Fix use of potentially uninitialized variable
Date:   Thu,  3 Oct 2019 17:53:48 +0200
Message-Id: <20191003154337.467869715@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>

commit 810f3b860850148788fc1ed8a6f5f807199fed65 upstream.

If ipc->ops.reply_msg_match is NULL, we may end up using uninitialized
mask value.

reported by smatch:
sound/soc/intel/common/sst-ipc.c:266 sst_ipc_reply_find_msg() error: uninitialized symbol 'mask'.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
Link: https://lore.kernel.org/r/20190827141712.21015-3-amadeuszx.slawinski@linux.intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/common/sst-ipc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/intel/common/sst-ipc.c
+++ b/sound/soc/intel/common/sst-ipc.c
@@ -211,6 +211,8 @@ struct ipc_message *sst_ipc_reply_find_m
 
 	if (ipc->ops.reply_msg_match != NULL)
 		header = ipc->ops.reply_msg_match(header, &mask);
+	else
+		mask = (u64)-1;
 
 	if (list_empty(&ipc->rx_list)) {
 		dev_err(ipc->dev, "error: rx list empty but received 0x%llx\n",



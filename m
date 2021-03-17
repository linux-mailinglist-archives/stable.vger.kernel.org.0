Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B61A333E323
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCQA4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229851AbhCQAzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EF2264F8C;
        Wed, 17 Mar 2021 00:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942548;
        bh=8lIR2o4v18WR/2YlHYIn96RC4k9ZocX631GO7STRiBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QzVAUuj68j1wv13I6kZoYqbz+0WoFQfQWjwufMboy+QlEoBYo392BQUdURQKF3Efl
         tW9+7mIZMHQO6EkvUDT6eKCV48VjptWgJJ4wecRBrvej/l6b9DWrqPU5SaD16wdbYM
         tl40plS0XfTzODoDvaZA/2axlH57nPtOie0FVYsbUi4a4q90kr+z6A04BJxYAvYoHj
         yE8nVQkXBxGEwkv4DZNyPgRDO8R82hmfKX1Yj3hkSzS5C0Gj3mccr3PuYeJOAmcpun
         apb54EmTquyptKtKi/OOHK8JskYwYDi7LDf4CiQFxdtzt71StFV51RrKnicw/1DZGh
         clX3mN89y3g/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Philipp Leskovitz <philipp.leskovitz@secunet.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 09/61] ALSA: hda: ignore invalid NHLT table
Date:   Tue, 16 Mar 2021 20:54:43 -0400
Message-Id: <20210317005536.724046-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit a14a6219996ee6f6e858d83b11affc7907633687 ]

On some Lenovo systems if the microphone is disabled in the BIOS
only the NHLT table header is created, with no data. This means
the endpoints field is not correctly set to zero - leading to an
unintialised variable and hence invalid descriptors are parsed
leading to page faults.

The Lenovo firmware team is addressing this, but adding a check
preventing invalid tables being parsed is worthwhile.

Tested on a Lenovo T14.

Tested-by: Philipp Leskovitz <philipp.leskovitz@secunet.com>
Reported-by: Philipp Leskovitz <philipp.leskovitz@secunet.com>
Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20210302141003.7342-1-markpearson@lenovo.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/intel-nhlt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/hda/intel-nhlt.c b/sound/hda/intel-nhlt.c
index d053beccfaec..e2237239d922 100644
--- a/sound/hda/intel-nhlt.c
+++ b/sound/hda/intel-nhlt.c
@@ -39,6 +39,11 @@ int intel_nhlt_get_dmic_geo(struct device *dev, struct nhlt_acpi_table *nhlt)
 	if (!nhlt)
 		return 0;
 
+	if (nhlt->header.length <= sizeof(struct acpi_table_header)) {
+		dev_warn(dev, "Invalid DMIC description table\n");
+		return 0;
+	}
+
 	for (j = 0, epnt = nhlt->desc; j < nhlt->endpoint_count; j++,
 	     epnt = (struct nhlt_endpoint *)((u8 *)epnt + epnt->length)) {
 
-- 
2.30.1


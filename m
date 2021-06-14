Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CEE3A648D
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhFNL0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:26:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236234AbhFNLYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:24:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF695619AC;
        Mon, 14 Jun 2021 10:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623668001;
        bh=PTfPcQyuNkeI2gBf2GfLOyEQ4pI5FTdwzZMDUroRB3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QI2IpBlsFOHQQNmX9cZnb23cRseLJ4lwFK9/FtZmOKDHWzSBCLrr8Z3XhzmwogBCt
         FhwcUxsI/3Un0mu2OS5Pds0runZ0yWrfDIRZAqhQLU2KeMo0Mjb2AoZ8fzEoaZipCv
         PN3CIIj35ShxjVHqq9n53pMr+OgKwxNGZqQ9a2QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.12 156/173] ASoC: SOF: reset enabled_cores state at suspend
Date:   Mon, 14 Jun 2021 12:28:08 +0200
Message-Id: <20210614102703.354758486@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
References: <20210614102658.137943264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit b640e8a4bd24e17ce24a064d704aba14831651a8 upstream.

The recent changes to use common code to power up/down DSP cores also
removed the reset of the core state at suspend. It turns out this is
still needed. When the firmware state is reset to
SOF_FW_BOOT_NOT_STARTED, also enabled_cores should be reset, and
existing DSP drivers depend on this.

BugLink: https://github.com/thesofproject/linux/issues/2824
Fixes: 42077f08b3 ("ASoC: SOF: update dsp core power status in common APIs")
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20210528144330.2551-1-kai.vehmanen@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -256,6 +256,7 @@ suspend:
 
 	/* reset FW state */
 	sdev->fw_state = SOF_FW_BOOT_NOT_STARTED;
+	sdev->enabled_cores_mask = 0;
 
 	return ret;
 }



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2941E14EF2
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfEFOhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfEFOhl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CC1721479;
        Mon,  6 May 2019 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153460;
        bh=AAZ0+3CCjkRjj7MejXcIyv6OzHqSdH3G6jmknbtzS7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUJfbtgsI7W6tPEXvRwhYt7xYroW7afOmlEEWDY6kif9fkicVQ4om79EFG+rZdQGl
         dB1XkRpBmtGFAVoNl4+UKtLH0UYkiFtNDQhQm8H3a0WzkbvUh5lmHgTGZ3G92y0ISa
         T2kRYPQNV2Siaip9j1WKzFYxhnGeQzWQlmudKgu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.0 097/122] ASoC: wm_adsp: Correct handling of compressed streams that restart
Date:   Mon,  6 May 2019 16:32:35 +0200
Message-Id: <20190506143103.474087266@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

commit 639e5eb3c7d67e407f2a71fccd95323751398f6f upstream.

Previously support was added to allow streams to be stopped and
started again without the DSP being power cycled and this was done
by clearing the buffer state in trigger start. Another supported
use-case is using the DSP for a trigger event then opening the
compressed stream later to receive the audio, unfortunately clearing
the buffer state in trigger start destroys the data received
from such a trigger. Correct this issue by moving the call to
wm_adsp_buffer_clear to be in trigger stop instead.

Fixes: 61fc060c40e6 ("ASoC: wm_adsp: Support streams which can start/stop with DSP active")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/wm_adsp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -3443,8 +3443,6 @@ int wm_adsp_compr_trigger(struct snd_com
 			}
 		}
 
-		wm_adsp_buffer_clear(compr->buf);
-
 		/* Trigger the IRQ at one fragment of data */
 		ret = wm_adsp_buffer_write(compr->buf,
 					   HOST_BUFFER_FIELD(high_water_mark),
@@ -3456,6 +3454,7 @@ int wm_adsp_compr_trigger(struct snd_com
 		}
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
+		wm_adsp_buffer_clear(compr->buf);
 		break;
 	default:
 		ret = -EINVAL;



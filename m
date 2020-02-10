Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEDA15754D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbgBJMkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgBJMkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8887720838;
        Mon, 10 Feb 2020 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338405;
        bh=gp3uSyvEdJvMJ43iWW0SHxrSkKLlqtLGRBb2o/xi1cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8IkUe8ehdkNmRtgvsxxnKXio1tU+oKAL1HBhh8xIlf8GKiX50YpC2oQmA/ENcykt
         TkrSzvsW5lquBqmWcHI0zCowHEYAJENadHAPmhK05TSO0wiW1cZR/O0W4yqVybPMZ+
         a0HDyi9n28O71+k7km5rLeXoDEoVDZ+5q9tBnwFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dragos Tarcatu <dragos_tarcatu@mentor.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 5.5 108/367] ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initialization order
Date:   Mon, 10 Feb 2020 04:30:21 -0800
Message-Id: <20200210122434.382312689@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 8ce1cbd6ce0b1bda0c980c64fee4c1e1378355f1 upstream.

The code which checks the return value for snd_soc_add_dai_link() call
in soc_tplg_fe_link_create() moved the snd_soc_add_dai_link() call before
link->dobj members initialization.

While it does not affect the latest kernels, the old soc-core.c code
in the stable kernels is affected. The snd_soc_add_dai_link() function uses
the link->dobj.type member to check, if the link structure is valid.

Reorder the link->dobj initialization to make things work again.
It's harmless for the recent code (and the structure should be properly
initialized before other calls anyway).

The problem is in stable linux-5.4.y since version 5.4.11 when the
upstream commit 76d270364932 was applied.

Fixes: 76d270364932 ("ASoC: topology: Check return value for snd_soc_add_dai_link()")
Cc: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20200122190752.3081016-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1906,6 +1906,10 @@ static int soc_tplg_fe_link_create(struc
 	link->num_codecs = 1;
 	link->num_platforms = 1;
 
+	link->dobj.index = tplg->index;
+	link->dobj.ops = tplg->ops;
+	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
+
 	if (strlen(pcm->pcm_name)) {
 		link->name = kstrdup(pcm->pcm_name, GFP_KERNEL);
 		link->stream_name = kstrdup(pcm->pcm_name, GFP_KERNEL);
@@ -1942,9 +1946,6 @@ static int soc_tplg_fe_link_create(struc
 		goto err;
 	}
 
-	link->dobj.index = tplg->index;
-	link->dobj.ops = tplg->ops;
-	link->dobj.type = SND_SOC_DOBJ_DAI_LINK;
 	list_add(&link->dobj.list, &tplg->comp->dobj_list);
 
 	return 0;



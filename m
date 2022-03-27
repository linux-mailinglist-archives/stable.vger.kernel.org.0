Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699B24E86DC
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiC0IPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 04:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiC0IPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 04:15:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3E54FC62;
        Sun, 27 Mar 2022 01:13:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c23so12277053plo.0;
        Sun, 27 Mar 2022 01:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=59JhUNktdVz2W5QJS5bzmJcf9POr7QzcmSfTOiXjcAE=;
        b=OZsDNWW6DNUFlcVYdlNaJI92YyM8e/1vdhm693Motn3WyZ7ewgAsXDxbdBNDuI8hff
         ajoCrHaYyEZxqHcVTVdfqmCiAlgd0sXnfwfy3HsjWeyb24TnljM/iNf1SvULyd3sonld
         udFONOi7HhP3xVedtAuHx8XnHifA5u4dM9VEFCjcFn/kOUfkAOqXQkJIAGRriZLaV8DV
         C8xCK72j0QcEf1Ns1y5NnE0u3qGfo2oNQvxJqmdJFiRrUyn+xamdElZdMcv9PZEVqfqB
         VYcWoqB6UFyBQXda/CLno4HvjFHNnAuiS6oH8SytVgsKNkS/xJtzOIQttmqvlM7Kz/jR
         Z2vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=59JhUNktdVz2W5QJS5bzmJcf9POr7QzcmSfTOiXjcAE=;
        b=Y+JJ5y2rVELqBr5kwgPE/XGi3gKLieTDS7LD2gHQpMEc71TN+aORjKd67iLbVmq4QY
         14pJrT7PeHqItJv1a0zTqWq6oS9bOSk0LsQxHLPER9rFPeavidNHErLOLSuzGTSSSDQO
         o3VB/PMT+lthcfBQCeokuycLcrQHXe7vC+xsHdrvV5RA5XqtqEiLL5S/QNqJ3ugZSDOn
         tL10VRQjbLVHm0Cve8rz8wdHxD+lT8hF2EAZdLOqHeReOHBgGJbmiCFDmWa+JseWdOCz
         zVWNUeCiPPH4j+AMSfdcDUqmL5xOsp8t0raCqGL+LXpa8PMoDNsT6zc9OvmMg6gbPtUP
         22/w==
X-Gm-Message-State: AOAM533tPR/sYFeSR3QPAmztnarXPvUlcgcpE2tuh8KXHkDpXFrf5uu3
        xvr/51vDXu9ertrwdvwJd+M=
X-Google-Smtp-Source: ABdhPJy/iTobgY0S2D+gB7aR16mC8LS3RFCSb2hnklRarrOtZksF+A58mZftxtdAe10MwlHGlfn4kQ==
X-Received: by 2002:a17:903:124a:b0:154:c860:6d52 with SMTP id u10-20020a170903124a00b00154c8606d52mr18220698plh.159.1648368799693;
        Sun, 27 Mar 2022 01:13:19 -0700 (PDT)
Received: from localhost ([115.220.243.108])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm12594343pfh.23.2022.03.27.01.13.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 27 Mar 2022 01:13:19 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     oder_chiou@realtek.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.com
Cc:     derek.fang@realtek.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] codecs: rt5682s: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 16:13:00 +0800
Message-Id: <20220327081300.12962-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
            if (!dai) {

The list iterator value 'dai' will *always* be set and non-NULL
by for_each_component_dais(), so it is incorrect to assume that
the iterator value will be NULL if the list is empty or no element
is found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD). Otherwise it will bypass the check
'if (!dai) {' (never call dev_err() and never return -ENODEV;)
and lead to invalid memory access lately when calling
'rt5682s_set_bclk1_ratio(dai, factor);'.

To fix the bug, just return rt5682s_set_bclk1_ratio(dai, factor);
when found the 'dai', otherwise dev_err() and return -ENODEV;

Cc: stable@vger.kernel.org
Fixes: bdd229ab26be9 ("ASoC: rt5682s: Add driver for ALC5682I-VS codec")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 sound/soc/codecs/rt5682s.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/rt5682s.c b/sound/soc/codecs/rt5682s.c
index 1e662d1be2b3..c890e51ff953 100644
--- a/sound/soc/codecs/rt5682s.c
+++ b/sound/soc/codecs/rt5682s.c
@@ -2686,14 +2686,11 @@ static int rt5682s_bclk_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	for_each_component_dais(component, dai)
 		if (dai->id == RT5682S_AIF1)
-			break;
-	if (!dai) {
-		dev_err(component->dev, "dai %d not found in component\n",
-			RT5682S_AIF1);
-		return -ENODEV;
-	}
+			return rt5682s_set_bclk1_ratio(dai, factor);
 
-	return rt5682s_set_bclk1_ratio(dai, factor);
+	dev_err(component->dev, "dai %d not found in component\n",
+		RT5682S_AIF1);
+	return -ENODEV;
 }
 
 static const struct clk_ops rt5682s_dai_clk_ops[RT5682S_DAI_NUM_CLKS] = {
-- 
2.17.1


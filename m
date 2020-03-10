Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54CEB17FB6F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731812AbgCJNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731810AbgCJNN6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:13:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D002468C;
        Tue, 10 Mar 2020 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583846038;
        bh=4TsMt/hkVyeNp32B7AhGN4QkaO1VpBI7eNal2nbGosw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiSP5eh136mcRzLoNPgcjmg2lJ8/UWjBR7fUPjLPCmOgbsi8vSFog4JPa2VjBWIXE
         qhEOZQdDpAEtnhoe3RnMuObPMpxc0xEtUfpFwkqR8+0NVUribTOazqMeylx0nem00s
         hISTIPBbxkkV1+YblOvp3K43Rih4mVTeuHz+AM04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 62/86] ASoC: intel: skl: Fix pin debug prints
Date:   Tue, 10 Mar 2020 13:45:26 +0100
Message-Id: <20200310124534.139727555@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124530.808338541@linuxfoundation.org>
References: <20200310124530.808338541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 64bbacc5f08c01954890981c63de744df1f29a30 upstream.

skl_print_pins() loops over all given pins but it overwrites the text
at the very same position while increasing the returned length.
Fix this to show the all pin contents properly.

Fixes: d14700a01f91 ("ASoC: Intel: Skylake: Debugfs facility to dump module config")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20200218111737.14193-2-tiwai@suse.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/skl-debug.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/intel/skylake/skl-debug.c
+++ b/sound/soc/intel/skylake/skl-debug.c
@@ -42,7 +42,7 @@ static ssize_t skl_print_pins(struct skl
 	int i;
 	ssize_t ret = 0;
 
-	for (i = 0; i < max_pin; i++)
+	for (i = 0; i < max_pin; i++) {
 		ret += snprintf(buf + size, MOD_BUF - size,
 				"%s %d\n\tModule %d\n\tInstance %d\n\t"
 				"In-used %s\n\tType %s\n"
@@ -53,6 +53,8 @@ static ssize_t skl_print_pins(struct skl
 				m_pin[i].in_use ? "Used" : "Unused",
 				m_pin[i].is_dynamic ? "Dynamic" : "Static",
 				m_pin[i].pin_state, i);
+		size += ret;
+	}
 	return ret;
 }
 



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CEE2FA9EA
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393866AbhARTQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390487AbhARLiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68B4D22B4E;
        Mon, 18 Jan 2021 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969884;
        bh=XwLX4nwBqB1UBtbBKWrkQ9vzJRD3mwXbxjGTkFit3pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIT9ih4+eeczpkN7GxYBEsju/0jJHBPnyfLzBkxJ4EfY92hBg0/bEOzWTH6x/iJBI
         aY45ElqN3Vx3LI/2gz+NxfVbxf+3VwQKnepLmAYrrm+KzpHXiOkpFLYSSb1wyop6z3
         95JmK4ao+fYffr/U+/1gDr3VRlqwmcihcfSfSxJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 03/76] ASoC: dapm: remove widget from dirty list on free
Date:   Mon, 18 Jan 2021 12:34:03 +0100
Message-Id: <20210118113341.150119367@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hebb <tommyhebb@gmail.com>

commit 5c6679b5cb120f07652418524ab186ac47680b49 upstream.

A widget's "dirty" list_head, much like its "list" list_head, eventually
chains back to a list_head on the snd_soc_card itself. This means that
the list can stick around even after the widget (or all widgets) have
been freed. Currently, however, widgets that are in the dirty list when
freed remain there, corrupting the entire list and leading to memory
errors and undefined behavior when the list is next accessed or
modified.

I encountered this issue when a component failed to probe relatively
late in snd_soc_bind_card(), causing it to bail out and call
soc_cleanup_card_resources(), which eventually called
snd_soc_dapm_free() with widgets that were still dirty from when they'd
been added.

Fixes: db432b414e20 ("ASoC: Do DAPM power checks only for widgets changed since last run")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Hebb <tommyhebb@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/f8b5f031d50122bf1a9bfc9cae046badf4a7a31a.1607822410.git.tommyhebb@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -2484,6 +2484,7 @@ void snd_soc_dapm_free_widget(struct snd
 	enum snd_soc_dapm_direction dir;
 
 	list_del(&w->list);
+	list_del(&w->dirty);
 	/*
 	 * remove source and sink paths associated to this widget.
 	 * While removing the path, remove reference to it from both



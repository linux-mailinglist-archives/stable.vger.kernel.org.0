Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899AB300D2B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbhAVT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbhAVOQ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:16:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E1B023A62;
        Fri, 22 Jan 2021 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324790;
        bh=X0rcrvuR1VPZ1hGlv8SnBMnotXQgQdwdkSlVnGGz+Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qop+7Tp7YEAbGXzHWGVMAf9rUoYZFGg9X5Sj9P1gBgOWVnxd/cP5yRn6X1uHlBQgA
         IRxmjOJBUorRTqHI5/pVXylq4TBaGD/tPjbk1bJcX00IHL68lC9A69y7KHO1oKAxhc
         CpN6Hci9dVjy8+d2Oqodf7zEMfqQLyROLB+AgLtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Hebb <tommyhebb@gmail.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 01/50] ASoC: dapm: remove widget from dirty list on free
Date:   Fri, 22 Jan 2021 15:11:42 +0100
Message-Id: <20210122135735.227274115@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
@@ -2434,6 +2434,7 @@ void snd_soc_dapm_free_widget(struct snd
 	enum snd_soc_dapm_direction dir;
 
 	list_del(&w->list);
+	list_del(&w->dirty);
 	/*
 	 * remove source and sink paths associated to this widget.
 	 * While removing the path, remove reference to it from both



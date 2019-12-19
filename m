Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76468126D5D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbfLSSjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbfLSSj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BF8720716;
        Thu, 19 Dec 2019 18:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780766;
        bh=2W/pubB/NGofUWGdwzpKRkBMf3PPruaJEe5OyHSlTYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8dcWiKABoxCGru/2jqhS7SkqDqQBBE2+fDAUte6V4GdFlhMCWCg/qX7hupe54+YH
         Ta5JNwMdYAP/GtEZmDfMs8GYNRvUhA7lrmAvlyy+n3rlsmHp6UTKUIeLeAs0XiRkLh
         UvbbHz6TZusIMZb8ZXB6sfomg5CTKKm+anZSxC0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawel Harlozinski <pawel.harlozinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.4 107/162] ASoC: Jack: Fix NULL pointer dereference in snd_soc_jack_report
Date:   Thu, 19 Dec 2019 19:33:35 +0100
Message-Id: <20191219183214.267661379@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>

commit 8f157d4ff039e03e2ed4cb602eeed2fd4687a58f upstream.

Check for existance of jack before tracing.
NULL pointer dereference has been reported by KASAN while unloading
machine driver (snd_soc_cnl_rt274).

Signed-off-by: Pawel Harlozinski <pawel.harlozinski@linux.intel.com>
Link: https://lore.kernel.org/r/20191112130237.10141-1-pawel.harlozinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-jack.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -80,10 +80,9 @@ void snd_soc_jack_report(struct snd_soc_
 	unsigned int sync = 0;
 	int enable;
 
-	trace_snd_soc_jack_report(jack, mask, status);
-
 	if (!jack)
 		return;
+	trace_snd_soc_jack_report(jack, mask, status);
 
 	dapm = &jack->card->dapm;
 



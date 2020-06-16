Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E861FB689
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgFPPiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730567AbgFPPiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:38:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF95820C56;
        Tue, 16 Jun 2020 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321891;
        bh=8oOdO8G5uDNdbKO90o2ZU39T1Bp6Ti8hqZkMXc9pX6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KlyOkRLjAVFooyhsy/zKVOv2Qk7dVEmA1J/u6BA9MFi/062aS/VD4VOw4fsMRpXGL
         /ROao15HpjOF0cpmiikmKWbvkwNm2ORiaQZgO29BeZqL0mR8A0/5WNauWE/aYyz0dI
         DuuEU+2vxQlWgGa+4be/pomkImmeyA54HQmhpOg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 056/134] ALSA: fireface: fix configuration error for nominal sampling transfer frequency
Date:   Tue, 16 Jun 2020 17:34:00 +0200
Message-Id: <20200616153103.456589269@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit bbd6aac3ae15bef762af03bf62e35ace5c4292bd upstream.

128000 and 192000 are congruence modulo 32000, thus it's wrong to
distinguish them as multiple of 32000 and 48000 by modulo 32000 at
first.

Additionally, used condition statement to detect quadruple speed can
cause missing bit flag.

Furthermore, counter to ensure the configuration is wrong and it
causes false positive.

This commit fixes the above three bugs.

Cc: <stable@vger.kernel.org>
Fixes: 60aec494b389 ("ALSA: fireface: support allocate_resources operation in latter protocol")
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20200510074301.116224-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/fireface/ff-protocol-latter.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/firewire/fireface/ff-protocol-latter.c
+++ b/sound/firewire/fireface/ff-protocol-latter.c
@@ -107,18 +107,18 @@ static int latter_allocate_resources(str
 	int err;
 
 	// Set the number of data blocks transferred in a second.
-	if (rate % 32000 == 0)
-		code = 0x00;
+	if (rate % 48000 == 0)
+		code = 0x04;
 	else if (rate % 44100 == 0)
 		code = 0x02;
-	else if (rate % 48000 == 0)
-		code = 0x04;
+	else if (rate % 32000 == 0)
+		code = 0x00;
 	else
 		return -EINVAL;
 
 	if (rate >= 64000 && rate < 128000)
 		code |= 0x08;
-	else if (rate >= 128000 && rate < 192000)
+	else if (rate >= 128000)
 		code |= 0x10;
 
 	reg = cpu_to_le32(code);
@@ -140,7 +140,7 @@ static int latter_allocate_resources(str
 		if (curr_rate == rate)
 			break;
 	}
-	if (count == 10)
+	if (count > 10)
 		return -ETIMEDOUT;
 
 	for (i = 0; i < ARRAY_SIZE(amdtp_rate_table); ++i) {



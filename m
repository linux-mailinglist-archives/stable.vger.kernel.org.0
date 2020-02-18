Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F12163255
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgBRT5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726911AbgBRT5o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:57:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D0FA24670;
        Tue, 18 Feb 2020 19:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055863;
        bh=oj6uAmJiAijYz3tJYNyBhtgI/KSxiSGRZ0l2McquZKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmXrXuRVngLWDzjFwt5PLGmr/6gE8l+GA6gkC6oAkeb0jC40tOQUgKCmxISmAu/lo
         Z3JxrHgq0Up/IF6Ze3CxDDclJThAhnyHMKh5RhiWv5hZN+k9M7UxyyYAcikdsEBiBo
         EJM7piZ1voK9+Bg0l4uHd++DKiuh85HlecNbbkHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 04/66] ALSA: usb-audio: Fix UAC2/3 effect unit parsing
Date:   Tue, 18 Feb 2020 20:54:31 +0100
Message-Id: <20200218190428.522860517@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit d75a170fd848f037a1e28893ad10be7a4c51f8a6 upstream.

We've got a regression report about M-Audio Fast Track C400 device,
and the git bisection resulted in the commit e0ccdef92653 ("ALSA:
usb-audio: Clean up check_input_term()").  This commit was about the
rewrite of the input terminal parser, and it's not too obvious from
the change what really broke.  The answer is: it's the interpretation
of UAC2/3 effect units.

In the original code, UAC2 effect unit is as if through UAC1
processing unit because both UAC1 PU and UAC2/3 EU share the same
number (0x07).  The old code went through a complex switch-case
fallthrough, finally bailing out in the middle:

  if (protocol == UAC_VERSION_2 &&
      hdr[2] == UAC2_EFFECT_UNIT) {
         /* UAC2/UAC1 unit IDs overlap here in an
          * uncompatible way. Ignore this unit for now.
          */
         return 0;
   }

... and this special handling was missing in the new code; the new
code treats UAC2/3 effect unit as if it were equivalent with the
processing unit.

Actually, the old code was too confusing.  The effect unit has an
incompatible unit description with the processing unit, so we
shouldn't have dealt with EU in the same way.

This patch addresses the regression by changing the effect unit
handling to the own parser function.  The own parser function makes
the clear distinct with PU, so it improves the readability, too.

The EU parser just sets the type and the id like the old kernels.
Once when the proper effect unit support is added, we can revisit this
parser function, but for now, let's keep this simple setup as is.

Fixes: e0ccdef92653 ("ALSA: usb-audio: Clean up check_input_term()")
Cc: <stable@vger.kernel.org>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206147
Link: https://lore.kernel.org/r/20200211160521.31990-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -897,6 +897,15 @@ static int parse_term_proc_unit(struct m
 	return 0;
 }
 
+static int parse_term_effect_unit(struct mixer_build *state,
+				  struct usb_audio_term *term,
+				  void *p1, int id)
+{
+	term->type = UAC3_EFFECT_UNIT << 16; /* virtual type */
+	term->id = id;
+	return 0;
+}
+
 static int parse_term_uac2_clock_source(struct mixer_build *state,
 					struct usb_audio_term *term,
 					void *p1, int id)
@@ -981,8 +990,7 @@ static int __check_input_term(struct mix
 						    UAC3_PROCESSING_UNIT);
 		case PTYPE(UAC_VERSION_2, UAC2_EFFECT_UNIT):
 		case PTYPE(UAC_VERSION_3, UAC3_EFFECT_UNIT):
-			return parse_term_proc_unit(state, term, p1, id,
-						    UAC3_EFFECT_UNIT);
+			return parse_term_effect_unit(state, term, p1, id);
 		case PTYPE(UAC_VERSION_1, UAC1_EXTENSION_UNIT):
 		case PTYPE(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2):
 		case PTYPE(UAC_VERSION_3, UAC3_EXTENSION_UNIT):



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F4157878
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730170AbgBJNIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729453AbgBJMjg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:36 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FD8A20661;
        Mon, 10 Feb 2020 12:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338376;
        bh=QQIPvfVxsHQ0Kg/jbhKAMrFoi+8fum2mpB8s9nGUJJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+h+Nl7G7IUxDgPeHDQmKjmxiGiMsLVtTZDyMI3ngr4by9k6Op//ec0OKu1UhOvbq
         h0wSOPJMWalXCH23/HSnBQKK7yt0p2EsoxNP6dSo+PHoAXAW1KZhFtzA01lEW/nIIM
         dpspk5BWh0YhMnjzqXtF4YMwVec5PwFAEhd1qpoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.5 051/367] ALSA: usb-audio: Fix endianess in descriptor validation
Date:   Mon, 10 Feb 2020 04:29:24 -0800
Message-Id: <20200210122428.752926995@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit f8e5f90b3a53bb75f05124ed19156388379a337d upstream.

I overlooked that some fields are words and need the converts from
LE in the recently added USB descriptor validation code.
This patch fixes those with the proper macro usages.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200201080530.22390-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/validate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -110,7 +110,7 @@ static bool validate_processing_unit(con
 	default:
 		if (v->type == UAC1_EXTENSION_UNIT)
 			return true; /* OK */
-		switch (d->wProcessType) {
+		switch (le16_to_cpu(d->wProcessType)) {
 		case UAC_PROCESS_UP_DOWNMIX:
 		case UAC_PROCESS_DOLBY_PROLOGIC:
 			if (d->bLength < len + 1) /* bNrModes */
@@ -125,7 +125,7 @@ static bool validate_processing_unit(con
 	case UAC_VERSION_2:
 		if (v->type == UAC2_EXTENSION_UNIT_V2)
 			return true; /* OK */
-		switch (d->wProcessType) {
+		switch (le16_to_cpu(d->wProcessType)) {
 		case UAC2_PROCESS_UP_DOWNMIX:
 		case UAC2_PROCESS_DOLBY_PROLOCIC: /* SiC! */
 			if (d->bLength < len + 1) /* bNrModes */
@@ -142,7 +142,7 @@ static bool validate_processing_unit(con
 			len += 2; /* wClusterDescrID */
 			break;
 		}
-		switch (d->wProcessType) {
+		switch (le16_to_cpu(d->wProcessType)) {
 		case UAC3_PROCESS_UP_DOWNMIX:
 			if (d->bLength < len + 1) /* bNrModes */
 				return false;



Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8130B1BCB47
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgD1Szt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbgD1ScC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 688DE21835;
        Tue, 28 Apr 2020 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098721;
        bh=pPmIFV+1g5lafog4sRGHQB4bxuzsE16raYDXiB2UHXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAFcM/RS63UB3Q4eBV2Q2TlPF4HT8a0O2ssGte32F3k/pIpePq/LzzkqWtP18pqB+
         bjdkilb8dtJnFBHeAlkmuxi8W01pbgHVrfh2ZIt++/XGA/KVw3xmBhnoX2aWmWFDzx
         GNqm7vr7q6S6vWZr8L8lOE1KJzUPBHSWGXxT9SaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lin Yi <teroincn@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.6 103/167] ALSA: usx2y: Fix potential NULL dereference
Date:   Tue, 28 Apr 2020 20:24:39 +0200
Message-Id: <20200428182238.198596131@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 7686e3485253635c529cdd5f416fc640abaf076f upstream.

The error handling code in usX2Y_rate_set() may hit a potential NULL
dereference when an error occurs before allocating all us->urb[].
Add a proper NULL check for fixing the corner case.

Reported-by: Lin Yi <teroincn@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200420075529.27203-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/usx2y/usbusx2yaudio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -681,6 +681,8 @@ static int usX2Y_rate_set(struct usX2Yde
 			us->submitted =	2*NOOF_SETRATE_URBS;
 			for (i = 0; i < NOOF_SETRATE_URBS; ++i) {
 				struct urb *urb = us->urb[i];
+				if (!urb)
+					continue;
 				if (urb->status) {
 					if (!err)
 						err = -ENODEV;



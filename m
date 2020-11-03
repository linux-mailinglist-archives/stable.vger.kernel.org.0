Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE992A5278
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgKCUuQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:50:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731774AbgKCUuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:15 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3852220719;
        Tue,  3 Nov 2020 20:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436614;
        bh=qx8wmItmrAlQijpvsRCgppHxF7uMHZ+9OEQSeHwfz7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZJ4kYIwauRQN13YO1jRdomaVJknuiC3ufECSyzPhVQfVEjVuueIBgifgl6nq4nx3
         nov4wrDiSWvUsIsoypWK0qJmyByej2Wp3ZW/TaVegf8SwbfncIPGwQ9iCYyOSJsIq0
         uUMiuBYoiqJ1IB+F4AjlmNI93nFtHwPY8Fh2abOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.9 327/391] drm/amd/display: Fix kernel panic by dal_gpio_open() error
Date:   Tue,  3 Nov 2020 21:36:18 +0100
Message-Id: <20201103203409.189635998@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 920bb38c518408fa2600eaefa0af9e82cf48f166 upstream.

Currently both error code paths handled in dal_gpio_open_ex() issues
ASSERT_CRITICAL(), and this leads to a kernel panic unnecessarily if
CONFIG_KGDB is enabled.  Since basically both are non-critical errors
and can be recovered, drop those assert calls and use a safer one,
BREAK_TO_DEBUGGER(), for allowing the debugging, instead.

BugLink: https://bugzilla.opensuse.org/show_bug.cgi?id=1177973
Cc: <stable@vger.kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/gpio_base.c
@@ -63,13 +63,13 @@ enum gpio_result dal_gpio_open_ex(
 	enum gpio_mode mode)
 {
 	if (gpio->pin) {
-		ASSERT_CRITICAL(false);
+		BREAK_TO_DEBUGGER();
 		return GPIO_RESULT_ALREADY_OPENED;
 	}
 
 	// No action if allocation failed during gpio construct
 	if (!gpio->hw_container.ddc) {
-		ASSERT_CRITICAL(false);
+		BREAK_TO_DEBUGGER();
 		return GPIO_RESULT_NON_SPECIFIC_ERROR;
 	}
 	gpio->mode = mode;



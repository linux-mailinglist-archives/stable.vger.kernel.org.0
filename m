Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380BD3285C6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbhCAQ6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:58:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235843AbhCAQxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:53:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A33764F27;
        Mon,  1 Mar 2021 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616449;
        bh=xyxK0sdbX3lht7i98gYeQ3dbCLpcnXc+TWLDD8MdZnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNaUHjweAEOux71b4N6i/TI3TjtmCILV+jUwP6/Q8wayPyTHjArzGzrKfLAG3GazC
         kFCKvNz2FChpdYJu7NCqCcEHYSQImduutkLmCF0454cLlrIV71b44VJE52YJtkpi35
         i8bjqtQ/MmZKSzC4IvtuJHZMGGiedDyCEaeT+7VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ludvig Norgren Guldhag <ludvigng@gmail.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 128/176] Input: i8042 - add ASUS Zenbook Flip to noselftest list
Date:   Mon,  1 Mar 2021 17:13:21 +0100
Message-Id: <20210301161027.347399251@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

commit b5d6e7ab7fe7d186878142e9fc1a05e4c3b65eb9 upstream.

After commit 77b425399f6d ("Input: i8042 - use chassis info to skip
selftest on Asus laptops"), all modern Asus laptops have the i8042
selftest disabled. It has done by using chassys type "10" (laptop).

The Asus Zenbook Flip suffers from similar suspend/resume issues, but
it _sometimes_ work and sometimes it doesn't. Setting noselftest makes
it work reliably. In this case, we need to add chassis type "31"
(convertible) in order to avoid selftest in this device.

Reported-by: Ludvig Norgren Guldhag <ludvigng@gmail.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Link: https://lore.kernel.org/r/20210219164638.761-1-mpdesouza@suse.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-x86ia64io.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -592,6 +592,10 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "10"), /* Notebook */
 		},
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "31"), /* Convertible Notebook */
+		},
 	},
 	{ }
 };



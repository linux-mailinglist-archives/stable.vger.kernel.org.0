Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCA86C72C
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390810AbfGRDW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389965AbfGRDIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:08:49 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8539E2173E;
        Thu, 18 Jul 2019 03:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419328;
        bh=1M5uP+m8cuTDZeta1c/3TZC1egzglcR2qlnV2iaMkKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywItR+a3s6EMUQdv/2OncAqMhXRnKIqLs7kNwxq/xRNO6yqUuMZJ9mEvbaCAVClXu
         bNby+PyaK8epSdLUwnPVul51oX36zNDRsdwSSarcUhUWM9kubeKae4c8vkHEDkwXLu
         VshP8eHRulxIUFQTxi4QPBDwBkl0YpMxkoI6F1K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cole Rogers <colerogers@disroot.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 03/80] Input: synaptics - enable SMBUS on T480 thinkpad trackpad
Date:   Thu, 18 Jul 2019 12:00:54 +0900
Message-Id: <20190718030059.064016486@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cole Rogers <colerogers@disroot.org>

commit abbe3acd7d72ab4633ade6bd24e8306b67e0add3 upstream.

Thinkpad t480 laptops had some touchpad features disabled, resulting in the
loss of pinch to activities in GNOME, on wayland, and other touch gestures
being slower. This patch adds the touchpad of the t480 to the smbus_pnp_ids
whitelist to enable the extra features. In my testing this does not break
suspend (on fedora, with wayland, and GNOME, using the rc-6 kernel), while
also fixing the feature on a T480.

Signed-off-by: Cole Rogers <colerogers@disroot.org>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -176,6 +176,7 @@ static const char * const smbus_pnp_ids[
 	"LEN0072", /* X1 Carbon Gen 5 (2017) - Elan/ALPS trackpoint */
 	"LEN0073", /* X1 Carbon G5 (Elantech) */
 	"LEN0092", /* X1 Carbon 6 */
+	"LEN0093", /* T480 */
 	"LEN0096", /* X280 */
 	"LEN0097", /* X280 -> ALPS trackpoint */
 	"LEN200f", /* T450s */



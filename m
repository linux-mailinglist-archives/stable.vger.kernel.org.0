Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662FE38A2C0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbhETJpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:45:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233635AbhETJnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:43:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9B2561442;
        Thu, 20 May 2021 09:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503166;
        bh=T7ouQa6THLRhC4bd2X38Hn//IR5jzpsL1WovxI8OXKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qARAg4ru826v2TeUsgYHlT97LB86y9hHJu6bll7PukevamG3wJnZYut686ymjT16t
         AELIChboGJTbfbKQTQqRCBiK2w1ob9rwBB1uPDwYa4uzDqWQ0mLz3O/gSkb8BFmmWb
         xWd1pAB+HjSHy2q0S4GUVoXj7TwoAULI2M0Aia/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Zhizhikin <andrey.z@gmail.com>
Subject: [PATCH 4.19 098/425] Fix misc new gcc warnings
Date:   Thu, 20 May 2021 11:17:47 +0200
Message-Id: <20210520092134.675290983@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e7c6e405e171fb33990a12ecfd14e6500d9e5cf2 upstream.

It seems like Fedora 34 ends up enabling a few new gcc warnings, notably
"-Wstringop-overread" and "-Warray-parameter".

Both of them cause what seem to be valid warnings in the kernel, where
we have array size mismatches in function arguments (that are no longer
just silently converted to a pointer to element, but actually checked).

This fixes most of the trivial ones, by making the function declaration
match the function definition, and in the case of intel_pm.c, removing
the over-specified array size from the argument declaration.

At least one 'stringop-overread' warning remains in the i915 driver, but
that one doesn't have the same obvious trivial fix, and may or may not
actually be indicative of a bug.

[ It was a mistake to upgrade one of my machines to Fedora 34 while
  being busy with the merge window, but if this is the extent of the
  compiler upgrade problems, things are better than usual    - Linus ]

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrey Zhizhikin <andrey.z@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c     |    2 +-
 drivers/media/usb/dvb-usb/dvb-usb.h |    2 +-
 include/scsi/libfcoe.h              |    2 +-
 net/bluetooth/ecdh_helper.h         |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -2951,7 +2951,7 @@ int ilk_wm_max_level(const struct drm_i9
 
 static void intel_print_wm_latency(struct drm_i915_private *dev_priv,
 				   const char *name,
-				   const uint16_t wm[8])
+				   const uint16_t wm[])
 {
 	int level, max_level = ilk_wm_max_level(dev_priv);
 
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -475,7 +475,7 @@ extern int __must_check
 dvb_usb_generic_write(struct dvb_usb_device *, u8 *, u16);
 
 /* commonly used remote control parsing */
-extern int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *, u8[], u32 *, int *);
+extern int dvb_usb_nec_rc_key_to_event(struct dvb_usb_device *, u8[5], u32 *, int *);
 
 /* commonly used firmware download types and function */
 struct hexline {
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -261,7 +261,7 @@ int fcoe_ctlr_recv_flogi(struct fcoe_ctl
 			 struct fc_frame *);
 
 /* libfcoe funcs */
-u64 fcoe_wwn_from_mac(unsigned char mac[], unsigned int, unsigned int);
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN], unsigned int, unsigned int);
 int fcoe_libfc_config(struct fc_lport *, struct fcoe_ctlr *,
 		      const struct libfc_function_template *, int init_fcp);
 u32 fcoe_fc_crc(struct fc_frame *fp);
--- a/net/bluetooth/ecdh_helper.h
+++ b/net/bluetooth/ecdh_helper.h
@@ -25,6 +25,6 @@
 
 int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 pair_public_key[64],
 			u8 secret[32]);
-int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 *private_key);
+int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32]);
 int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64]);
 int generate_ecdh_keys(struct crypto_kpp *tfm, u8 public_key[64]);



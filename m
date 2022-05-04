Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033FA51A5F6
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353667AbiEDQwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353657AbiEDQwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E393947044;
        Wed,  4 May 2022 09:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60078B827A1;
        Wed,  4 May 2022 16:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1203C385AA;
        Wed,  4 May 2022 16:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682902;
        bh=Y1qldisk8Lv4E9gahULwsrbZv9Dzw/IFq3UUntaIz9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SamySnADRAPaE7I+uPUBHDB1hJQkPbqT2K9YeAUezIfH6Fcx+4r9nELaJvEejNdjP
         0Ix1iSlnHItqMOqMVaf1k5fQnj51rzPTgVugGqwaZho0Ys41BokbFsDSC5vjFkvFWV
         +9xolKwqMtOSFBYWoErHuNgztyCAdVedll6GgDhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 08/84] USB: serial: whiteheat: fix heap overflow in WHITEHEAT_GET_DTR_RTS
Date:   Wed,  4 May 2022 18:43:49 +0200
Message-Id: <20220504152928.328055478@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit e23e50e7acc8d8f16498e9c129db33e6a00e80eb upstream.

The sizeof(struct whitehat_dr_info) can be 4 bytes under CONFIG_AEABI=n
due to "-mabi=apcs-gnu", even though it has a single u8:

whiteheat_private {
        __u8                       mcr;                  /*     0     1 */

        /* size: 4, cachelines: 1, members: 1 */
        /* padding: 3 */
        /* last cacheline: 4 bytes */
};

The result is technically harmless, as both the source and the
destinations are currently the same allocation size (4 bytes) and don't
use their padding, but if anything were to ever be added after the
"mcr" member in "struct whiteheat_private", it would be overwritten. The
structs both have a single u8 "mcr" member, but are 4 bytes in padded
size. The memcpy() destination was explicitly targeting the u8 member
(size 1) with the length of the whole structure (size 4), triggering
the memcpy buffer overflow warning:

In file included from include/linux/string.h:253,
                 from include/linux/bitmap.h:11,
                 from include/linux/cpumask.h:12,
                 from include/linux/smp.h:13,
                 from include/linux/lockdep.h:14,
                 from include/linux/spinlock.h:62,
                 from include/linux/mmzone.h:8,
                 from include/linux/gfp.h:6,
                 from include/linux/slab.h:15,
                 from drivers/usb/serial/whiteheat.c:17:
In function 'fortify_memcpy_chk',
    inlined from 'firm_send_command' at drivers/usb/serial/whiteheat.c:587:4:
include/linux/fortify-string.h:328:25: warning: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
  328 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Instead, just assign the one byte directly.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202204142318.vDqjjSFn-lkp@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220421001234.2421107-1-keescook@chromium.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/whiteheat.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -599,9 +599,8 @@ static int firm_send_command(struct usb_
 		switch (command) {
 		case WHITEHEAT_GET_DTR_RTS:
 			info = usb_get_serial_port_data(port);
-			memcpy(&info->mcr, command_info->result_buffer,
-					sizeof(struct whiteheat_dr_info));
-				break;
+			info->mcr = command_info->result_buffer[0];
+			break;
 		}
 	}
 exit:



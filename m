Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A60509419
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 02:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383385AbiDUAPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 20:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244872AbiDUAPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 20:15:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A081A060
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:12:36 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d15so3260340pll.10
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZ4DQrUT0teh2OCHLccoXzTPXFLo3iiH/Aggk2F56Hg=;
        b=B42U8RHKbCW+dc4LpDeKZT8c8MND7ONSahnG4v/GlOuP3U9dbEKh6rL6z4rMDfWacR
         YDSvoZ8pHgISE2TrrAS0iZkbiuBCYeG6TUa0duCosI4AOZXN9FXOcxdZcOrYeuv6zGtK
         rkMFXd1fPr3ugLhaBEgvReSoHR2nmD2ADfyGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mZ4DQrUT0teh2OCHLccoXzTPXFLo3iiH/Aggk2F56Hg=;
        b=2XM3VLGpJuXZEKJx36QNNJlkjWF/XL7LmcwHf45Dwx8ZgX7UMfKVABOikNyee7dom9
         7wAEJaw4oarkDQdYkdvMLRYT9Zqcbqtg2m9DD/eJWTTI+wsjY328QYJz0Bmuls3+9nK6
         mp+tdl3hbVRIN1+PQHsv73BK9w+k4b8wAbK0du5CDCzzhiNXJ6Vg/8yancJyG9jsJJT8
         H3QLW2N1cruUm2xeGdbAbMO/eFTaDwVkYaxBTpv5/DrMEKx/2Ngz7ny3uNDPCLvsCV7V
         0+ZJlHjVfo+H472iqstf2pspfqG9GZg2ga+W81Uf5p4UXPfRzyFYFNdcM8+X5L/R3dKJ
         7bcA==
X-Gm-Message-State: AOAM530G7+VO0mQKc4G0Mg0+Q3j0FEyS76MfOionCx4oJH5788nfTNGc
        l/bPFoVtG62V3QJ/ch23tv6K2g==
X-Google-Smtp-Source: ABdhPJwdM10iVXVT4GgVJ7n68bXRc4XF9sp4PCqnh2QPb5tgmj8tUrfXT6ObEnzuRE/TzvsSI3P/cw==
X-Received: by 2002:a17:902:cecb:b0:158:9a0b:c839 with SMTP id d11-20020a170902cecb00b001589a0bc839mr22007105plg.58.1650499956459;
        Wed, 20 Apr 2022 17:12:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm21198168pga.38.2022.04.20.17.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 17:12:36 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] USB: serial: Fix heap overflow in WHITEHEAT_GET_DTR_RTS
Date:   Wed, 20 Apr 2022 17:12:34 -0700
Message-Id: <20220421001234.2421107-1-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3048; h=from:subject; bh=27sA78q0oVmYGS0XfXLNtfdHOOZSlXQQsmiidfepGiM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiYKFxlmtHj212PdV32XRZoSS1OuohiF8aXa+eAnEi uF3EZFKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYmChcQAKCRCJcvTf3G3AJt1SD/ wIA5Ub4jPeBldsKvd0TU9ZGzRKJ2m3utc987tW5kJirN4PIYWyvyvoEbO6rSSEzZ8hpIH7ypA2dtSE yeTdYwaBQR3Q6HxrVBDC7TU15XzdQludQ6ar8yL5JoH8yn6omH7AxRe1OOhh5YLo8lqFDsXzQhI5Xn 35MZsHPZs21sP7lR4XU17SK7K6VRWOb6oR6fkmW1xB/0mG87IiimtO0LMSLo4FRSgw6kKOQZyhdQwJ lQQH5dFl6DqEGx0Ublm44BRZ6PUd+bUuGa3fbAKVK4ZkCQ6EEnqxLiBuyhmf/DcUTPAzJSO0b7xi0E DzrzAKxacn9Go1NfeAwHHPYNB2PY2kqcGqqXOsUQdD1cj5ugYICOwsAjEtga2CGJnlCIbxcT2UYD6E YB4dweO4RUSNphc/Pih/xZwmMignRP2S7P+/C0tyfrfEY/5krd/yktNv6kYacwphMJu6XaFHG8j0yq 1dJ+u6X7tFxzf/gDSvbzNyDDsQOd/++G0XqHVD7QD9y7lF+Pq7Hibhw/2WsKGrYRgT3n+juSH/59rw B174TvjeYgAgfMLO6qphWf2S3K24S6h4EJUd9su3a77JTZYA/eOYRxdCKydzddWseKoHqrkGk6thGF nstFY+p0WOtloFx8MNBIoCWBrtRPT0qEeCWwOWPzYjvf1HLqYqPRYvCwa3Bg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v1: https://lore.kernel.org/lkml/20220419041742.4117026-1-keescook@chromium.org/
v2: - just assign the single byte
---
 drivers/usb/serial/whiteheat.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index da65d14c9ed5..06aad0d727dd 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -584,9 +584,8 @@ static int firm_send_command(struct usb_serial_port *port, __u8 command,
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
-- 
2.32.0


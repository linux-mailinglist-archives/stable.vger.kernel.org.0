Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820BB5A96CA
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiIAM3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIAM3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 08:29:01 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF6B126DCF
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 05:28:18 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id k18so11311309lji.13
        for <stable@vger.kernel.org>; Thu, 01 Sep 2022 05:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=5T5wLLEDu6OXsS2oU34K7c5tkwyKBh84Iru8P2pYD9I=;
        b=GXfLi0rinPBFI+Y1+c79/x/z41Kvmglxd+/cvSQPM7Sj9twWHGcY81goNlpMQRCmnL
         vvVnk0aNGqKhekQUI8KHxmkdNGvNcrP7q9C7fYTMYIfc+taJmg3ISYXNmj7eWWJtaO63
         Qf5mrQiRo824BX+LCws4yweo12unNURAfGsQXhBKO1ZM/AtMB2RbXPfWXrtCQUFATiYf
         dftEpqivOx9vgJOeFB9lmXBIZMfT8JlJNVr3lX25rGrBSfq2c5YOEHOmDOjzzB4CHMmF
         4yTY2KNurXzelIaB5rC/D6OoZ5K07AIOxAtYqi+lkqFHX3o1sghvnhG/2kUnRmolyXPH
         dnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=5T5wLLEDu6OXsS2oU34K7c5tkwyKBh84Iru8P2pYD9I=;
        b=n6g8Q2Abexl9RkIcKNawMYbShtqV3hPMint7uctV3+7FQ5gbwrF9Tl6U8ThWTbuSss
         ShHZW6apRPtDdQx4SzRmnPZ23baUy26dxTomLtxjLJ/40Vy8bAkiwGeBG9dZasOFNZEn
         ycS1pUa6GyNLID9JJe1T81hSwf9crhWXpILyQshBtfrwziOxLzuG2v2B6BNclxForsMc
         ylWIpw3PBPN6HB26n4kxEHbLbqa8ctnBB0EFspAxYcJlYVTLEm/8u/vGOHoQVOyFOlcz
         cbNkQ+d4B8EHRqejWz5GUhU1J3JTjHQnDYVCvh2bgu+fABFEUmkg+LHPrWzQH70i26cb
         jIFQ==
X-Gm-Message-State: ACgBeo0/l0/6NdXqSue7MQ50XDZrjSlGLOuK5V2GbZMS0U5N6MROcpRq
        nHe6vthM1SEU+WoUyDSPJTGHIQ==
X-Google-Smtp-Source: AA6agR7w9/ZU+B6UvHi19zf2ywpNMcrudteufAcQ9LFAeRCBnzDX8YORiW0t75xx5ew7ETU0Y1I2pQ==
X-Received: by 2002:a2e:b8d6:0:b0:268:9b1d:5084 with SMTP id s22-20020a2eb8d6000000b002689b1d5084mr1822843ljp.37.1662035296408;
        Thu, 01 Sep 2022 05:28:16 -0700 (PDT)
Received: from fb10a0c5d590.. (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id s12-20020a056512202c00b00492c2394ea5sm125935lfs.165.2022.09.01.05.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:28:16 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Anssi Hannula <anssi.hannula@bitwise.fi>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v3 00/15] can: kvaser_usb: Various fixes
Date:   Thu,  1 Sep 2022 14:27:14 +0200
Message-Id: <20220901122729.271-1-extja@kvaser.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series was originally posted by Anssi Hannula [1].
In v2 I rebased and updated some of the patches [2].

Changes in v3:
 - Rebase on top of commit
   1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
 - Add Tested-by: Anssi Hannula
 - Add stable@vger.kernel.org to CC.
 - Add my S-o-b to all patches
 - Fix regression introduced in
   [PATCH v2 04/15] can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device,
   found by Anssi Hannula [3]

[1]
https://lore.kernel.org/linux-can/20220516134748.3724796-1-anssi.hannula@bitwise.fi
[2]
https://lore.kernel.org/linux-can/20220708115709.232815-1-extja@kvaser.com
[3]
https://lore.kernel.org/linux-can/b25bc059-d776-146d-0b3c-41aecf4bd9f8@bitwise.fi

Anssi Hannula (10):
  can: kvaser_usb_leaf: Fix overread with an invalid command
  can: kvaser_usb: Fix use of uninitialized completion
  can: kvaser_usb: Fix possible completions during init_completion
  can: kvaser_usb_leaf: Set Warning state even without bus errors
  can: kvaser_usb_leaf: Fix TX queue out of sync after restart
  can: kvaser_usb_leaf: Fix CAN state after restart
  can: kvaser_usb_leaf: Fix improved state not being reported
  can: kvaser_usb_leaf: Fix wrong CAN state after stopping
  can: kvaser_usb_leaf: Ignore stale bus-off after start
  can: kvaser_usb_leaf: Fix bogus restart events

Jimmy Assarsson (5):
  can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
  can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event
    to {leaf,usbcan}_cmd_can_error_event
  can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
  can: kvaser_usb: Add struct kvaser_usb_busparams
  can: kvaser_usb: Compare requested bittiming parameters with actual
    parameters in do_set_{,data}_bittiming

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  32 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 118 +++-
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 166 ++++--
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 543 ++++++++++++++++--
 4 files changed, 764 insertions(+), 95 deletions(-)

-- 
2.37.3


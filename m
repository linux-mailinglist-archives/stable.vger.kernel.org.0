Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C0654726A
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 08:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiFKGtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 02:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiFKGtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 02:49:33 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48CD120B6;
        Fri, 10 Jun 2022 23:49:29 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o8so1091743wro.3;
        Fri, 10 Jun 2022 23:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=2mnLJx/YLtGg6XB3yrCKXBONKfuMv1V1OCyuSTcWLew=;
        b=UEHygF8XU7HI1eHnGVcveKltbaP0GmmI92POtL5a6zilfHSvYYnTKPrt2HU021uGSd
         G5IDJoCyRnSK7IDadSVPwtjewfuk/1I2Zw1/FgHm7iE31gWkzUBjUIHjqFA4a6Uwbgsm
         hPUFrdYQlzW5YipDjGielnHHQjziwUkm+6TRoZXYs0PM5JIL4bi3ra9k4tnOt9sSnzqT
         Amy17oPNgWQcnWaJs+dJXZgRIUv9IOFNCxH9EyWss/X1mauFtGSKxdw7iIB7bmkNxTuV
         wurBKBOBfmNNkJE0RcTB5P3edmQdmCz3wlGjgQgoUERW/Fl/t2JhZ89k9TQtjPBQHKZD
         LudQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=2mnLJx/YLtGg6XB3yrCKXBONKfuMv1V1OCyuSTcWLew=;
        b=K3bu8DWBb4Vu2Yeqt7Gq20FqkP4VNIRmSXu5M9Wxn+75DrD1Vkjuni1DRcYtLhbz20
         8iKNAAcuihPjU8ZoiS/CPrfrxSBIen4HZpoImuTcsA9KCT/HWnSquuPz78+iDJ8A/y85
         51XZxOzoC3pYHK2bvN09IgmCITg/e1emb5UEG6abdNuUWCdAIASFNbj7ZV5ltSPZEDEg
         X4HskAnitWyjl5KlEH/PH9RTn31GHG/dwK/4+5cVQetSj9ekoqgjdxwMJFVwC3/fpDh8
         B3eqgKCVGmLKg3+/vk0QMtnDUxsQoxmr7K6cUSFugN8LBphWvaIZYIsjWvdVDnG5mvDQ
         Maqw==
X-Gm-Message-State: AOAM533G7ltvrFkqlJMbyiC5VvHPmDhhbrY7FwvWsjRKceThTS8+41YW
        gTY8njP+IfnRYqgeRmHw/ZYYfpQEGnf+Aw==
X-Google-Smtp-Source: ABdhPJxHNyWOzUNETd/M21rDxElmX7TvMc2ZdG8j8u5bGnHDc5kubegQK/UQxGq7RhBoJ4IviPS9Kg==
X-Received: by 2002:a5d:4c47:0:b0:210:2f9f:a21b with SMTP id n7-20020a5d4c47000000b002102f9fa21bmr48064948wrt.493.1654930168120;
        Fri, 10 Jun 2022 23:49:28 -0700 (PDT)
Received: from smtpclient.apple ([167.99.200.149])
        by smtp.gmail.com with ESMTPSA id k11-20020a056000004b00b0020d02262664sm1580865wrx.25.2022.06.10.23.49.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jun 2022 23:49:27 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Regression in 5.18.3 from "xhci: Set HCD flag to defer primary
 roothub registration"
Message-Id: <743F7369-2794-4189-8891-5DA62E4B62DA@gmail.com>
Date:   Sat, 11 Jun 2022 10:49:23 +0400
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Chris Chiu <chris.chiu@canonical.com>,
        linux-usb@vger.kernel.org, linux-amlogic@lists.infradead.org,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6c64a664e1cff339ec698d803fa8cbb9af5d95ce =E2=80=9Cxhci: Set HCD =
flag to defer
primary roothub registration=E2=80=9D added for Linux 5.18.3 caused a =
regression on
some Amlogic S912 devices (original user forum report with an Android TV =
box
and confirmed with a Khadas VIM2 board). I do not see issues with older =
S905
(WeTeK Play2) or newer S922X (Odroid N2+) devices running the same =
kernel.
There are no kernel splats or error messages but lsusb shows no output =
and
nothing works. Simple revert restores the previous good working =
behaviour.

dmesg with commit http://ix.io/3ZTv
dmesg with revert http://ix.io/3ZTw

I=E2=80=99m not a coder so will need to be fed instructions to assist =
with debugging
the issue further if you don't have access to an Amlogic S912 device. I =
can
share devices online for remote poking around if needed.

Christian=

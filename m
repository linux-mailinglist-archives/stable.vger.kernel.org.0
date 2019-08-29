Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83040A19A5
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 14:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfH2MNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 08:13:23 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:44058 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfH2MNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 08:13:23 -0400
Received: by mail-lj1-f174.google.com with SMTP id e24so2765053ljg.11
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 05:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8ofBdj932X0N5pbIjncN/Og4+lEQ42JtUVWcW4QCUEQ=;
        b=XfRmHL6o8jYDqU4Fc7PkYcFqo9S2yQe3STancpyxRbtXDup8enoH0xAYrnOBkoHgTu
         j54mQDeDK+G8jTnzWCo5LiPfPifizN5htTkf2vnJdQIy7zh7x0YWUjZ+Z2feAlgCqiC7
         mMBqyxjCfwhhEsY9Li2d7aFudMYCuq2NQDHMwrQN1CceljVqcXrdQEkzkiRijBK4AdfJ
         rk1oNEEd3JR5ZcOySBfiby3P8IxCfVcJEkAuSB56wWZFc2t5A/FLpF5lbmh+nlEniMcP
         BXXwWaNQ5KqLeA5IUdfPpbaaTs0l05+RhHzHSbU10vh5VipA2Ox3UPgQlBwEbQPXQpHn
         f5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8ofBdj932X0N5pbIjncN/Og4+lEQ42JtUVWcW4QCUEQ=;
        b=LUwwa+vmz1jcIYLz/ydeR6H2/kAcRhWwSTYScK5XranFkACUhygIEQPzFTkGBxbnui
         YcQ4SP2vYZfsUDxuI1PSEokY8PsDDY6IvkoLLOoUiZmaVvyUDidZk3sVvHhrsSwbFIwO
         P8uMakpvz4yjnKf4LOhEweLxy7n1TQV6tUFQ0mCx6D4sAZsiIjeVM3rkcXT2DRxPNC2t
         0p6GTHv/B5Y3lz413hhNsCDmFB2vTz3c/wbLAHzCbmwXMubPlMezJpF1wzNyzfhTo9Wm
         GdcDHucnLenuRJzROsOHAlXgdcnGNjMLUX78R3wA/gaCMtZgIWhZ8WZGnU1fmQ8zi+Qe
         kxbQ==
X-Gm-Message-State: APjAAAXBssOhX+tbjf9AwATaQfbPK63yD9Tecx5WfTpZjDkCYKvcCoRe
        YuH+yUqzpEkc2luEoJAPzD7Wg+GmUWEnrLgF1S2DmHMqZqE=
X-Google-Smtp-Source: APXvYqz83MPqFU3kvB6ivIrEZqLYjwaRPbbEyg/zcvVvc4F/SU60aI6aKFT32+C4DIcKv4toQoX7CWD6HTGoxXeQ96I=
X-Received: by 2002:a2e:958e:: with SMTP id w14mr5192450ljh.126.1567080801096;
 Thu, 29 Aug 2019 05:13:21 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Fran=C3=A7ois_Valenduc?= <francoisvalenduc@gmail.com>
Date:   Thu, 29 Aug 2019 14:13:10 +0200
Message-ID: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
Subject: Kernel 5.2.11 dpes not compile
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following patch causes a build failure:


Author: Henry Burns <henryburns@google.com>
Date:   Sat Aug 24 17:55:06 2019 -0700

    mm/zsmalloc.c: fix race condition in zs_destroy_pool

I get this error:

 CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
  CHK     include/generated/compile.h
  CC      mm/zsmalloc.o
In file included from ./include/linux/mmzone.h:10:0,
                 from ./include/linux/gfp.h:6,
                 from ./include/linux/umh.h:4,
                 from ./include/linux/kmod.h:9,
                 from ./include/linux/module.h:13,
                 from mm/zsmalloc.c:33:
mm/zsmalloc.c: In function =E2=80=98zs_create_pool=E2=80=99:
mm/zsmalloc.c:2435:27: error: =E2=80=98struct zs_pool=E2=80=99 has no membe=
r named
=E2=80=98migration_wait=E2=80=99
  init_waitqueue_head(&pool->migration_wait);
                           ^
./include/linux/wait.h:67:26: note: in definition of macro =E2=80=98init_wa=
itqueue_head=E2=80=99
   __init_waitqueue_head((wq_head), #wq_head, &__key);  \
                          ^~~~~~~
scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
make[1]: *** [mm/zsmalloc.o] Error 1
Makefile:1073: recipe for target 'mm' failed

You can find my configuration file attached.

Does anybody have any idea about this ?
Thanks in advance,

Fran=C3=A7ois Valenduc

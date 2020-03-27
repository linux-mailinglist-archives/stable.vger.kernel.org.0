Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB1F71957C0
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 14:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgC0NL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 09:11:59 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:41353 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgC0NL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 09:11:58 -0400
Received: by mail-ot1-f52.google.com with SMTP id f52so9595291otf.8
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 06:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=1Dd6kzRbtZe6HYQ+jorBihp2W8go1iGX8kErxL/Dvw8=;
        b=bz+T2+PqdhAOntlnGAcnDtRM/erhVq3Y7d+BoQD2SQW2g/wxyY8hjYhbEAR08o1nAT
         r76/W7KsOkwHowBWfw9LTYzSSglGaw5yrjMpXJGLUuQGNRAkxLyIj7/W30IL79MXct8X
         k5p/mZWcSdgbeCGoFt8jUMCkMmuxgdjRJffI0dCBZSIDPrIIFiQfd7jL3ioavfZlaoOZ
         iHalj4yAFoy6ueKWfGafOjBEds0L7Td3yXq9n5fRFgLJ42l44whAXGXXS7wf4kLGTESJ
         lqdfOcTvus6wCtNBNTOC23sIuTwAIzmeUzErAV/QlpnvxHQtrI/0voybzfs6Bs382X5/
         AYbg==
X-Gm-Message-State: ANhLgQ3PV1C+bXHd7ZLV7HGok0cyVCYVr4Vj0IexE/7iTKWhKB9WIPSV
        gldb/JXX5hVpIafUdSd/Ty6JDD8ev9qUC//YCrM=
X-Google-Smtp-Source: ADFU+vsCNT7UWNgcDySNL7V1+WqUoHDuetKklFpQK46rxruvRctboMOozIp0AA+SN1oOHPIkhUMTUDd64Ap4B50zHu0=
X-Received: by 2002:a05:6830:14cc:: with SMTP id t12mr9811604otq.118.1585314717789;
 Fri, 27 Mar 2020 06:11:57 -0700 (PDT)
MIME-Version: 1.0
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 27 Mar 2020 14:11:46 +0100
Message-ID: <CAJZ5v0izbXdxMWZaySokD+7smnZhSpjOJy5DQGNG+Dw3+iFVZQ@mail.gmail.com>
Subject: Commit 024aa8732acb for 5.4.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg at al,

Please the following commit:

commit 024aa8732acb7d2503eae43c3fe3504d0a8646d0
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Nov 28 23:50:40 2019 +0100

    ACPI: PM: s2idle: Rework ACPI events synchronization

    Note that the EC GPE processing need not be synchronized in
    acpi_s2idle_wake() after invoking acpi_ec_dispatch_gpe(), because
    that function checks the GPE status and dispatches its handler if
    need be and the SCI action handler is not going to run anyway at
    that point.

    Moreover, it is better to drain all of the pending ACPI events
    before restoring the working-state configuration of GPEs in
    acpi_s2idle_restore(), because those events are likely to be related
    to system wakeup, in which case they will not be relevant going
    forward.

    Rework the code to take these observations into account.

    Tested-by: Kenneth R. Crudup <kenny@panix.com>
    Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>


into 5.4.y as it is needed to fix an ACPI wakeup events
synchronization issue in suspend-to-idle.

Note that this commit was present in 5.5.0, so 5.4.y is the only
-stable series needing this fix.

Cheers,
Rafael

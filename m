Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69166274221
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 14:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgIVMhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 08:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgIVMhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 08:37:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173D6C061755;
        Tue, 22 Sep 2020 05:37:15 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g128so19293550iof.11;
        Tue, 22 Sep 2020 05:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFQzsuujKElV6LtzLXsM0uz/7sKSzxEF2swvXixbgcU=;
        b=pPZFEYz772Y00aL6I89bLezhZ1ZSA+934tPUMBBiooGMWH19SXpJ8bl10e06NmMYWr
         BuK/9pGS4qwZFIdpuGZmydXZxaxWXKBvslrO1C9ZY4VgVmNmTnqpbL7iFlf4sjR1Vo3r
         sI2xwGwV/jaAtOXb49k9udGvyJ/bbFRTDOGx6K7Xekik/1B43qONcRllYBUW8jMLSMdj
         ID2fqpZQwgvAnMkm9GNjMg0OP/4/FEMMaX8OQeXdD0wCmcMlTx+VP5UgVq7HcOfLVF9P
         TI7cwfDv+ekZ333Lu9auSteTza9zPTrN1UpsXjROHSAwv8yhy5P4YPG6ZypqSDzKUedh
         Y5Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFQzsuujKElV6LtzLXsM0uz/7sKSzxEF2swvXixbgcU=;
        b=kbzfBpau6iB6GAyUgVg5A6mIAVxgkOp0upsu4qtlRGq+j2eV96jaYdGtMDjDw5JayD
         UTjk10PUuPpxl91XxGSRbiOvM9A5Pi/bnWkLXbkr8vZlshzx5xVyvUF10K8kOF7bZ3t9
         ybUmrJUQyCeoBB6N8KGAamM8QcraRmsI3RM5rYPUxIVkdlvQW0iA6n5I1K4WujimV6ir
         IZJtbtwgXRm8Nz/kZ2TS/eS1MvTNfC4N5S/tTFLW8UYc+cFRirOCBMAWZUFYsCLv5xLg
         yFUAkROnQwvU4xPdMVh74Vi7q6//95pHzzRRFJd15s9NnmrndkY5FaCsMYdEY8VMzwYQ
         Vhig==
X-Gm-Message-State: AOAM533Ln1QzMlolPRgrOHEvnQ/k2x0WDHityqVPoU43N0mgrKckAcEy
        3dlw1v5VvCE6Dq26R32ROkw9jOpMfMra/NMVMac=
X-Google-Smtp-Source: ABdhPJxye/MkIp551boOR1WwfOkduVFP0l+ez27MYGdisf+spj9/XVdhXZ8I4q+9AKlggFGWhalMz+fJ3lALpCJVGkg=
X-Received: by 2002:a05:6638:587:: with SMTP id a7mr3788125jar.72.1600778233885;
 Tue, 22 Sep 2020 05:37:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200922114905.2942859-1-gch981213@gmail.com> <20200922120112.GS4792@sirena.org.uk>
In-Reply-To: <20200922120112.GS4792@sirena.org.uk>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Tue, 22 Sep 2020 20:37:02 +0800
Message-ID: <CAJsYDVLsBm9pnjd5hbDptXXN3Vd7e=cpuDMc-d-XZ-k46j9ztQ@mail.gmail.com>
Subject: Re: [PATCH v2] spi: spi-mtk-nor: fix timeout calculation overflow
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-spi@vger.kernel.org,
        =?UTF-8?B?QmF5aSBDaGVuZyAo56iL5YWr5oSPKQ==?= 
        <bayi.cheng@mediatek.com>, stable@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 22, 2020 at 8:02 PM Mark Brown <broonie@kernel.org> wrote:
> (which we should pay attention to in the core for flash
> stuff but IIRC we didn't do that yet).

BTW we do have that taken care. spi_mem_adjust_op_size will
adjust the transfer size according to max_transfer/message_size
if no custom adjust_op_size hook is defined in the driver. If a custom
adjust_op_size is defined, the driver adjusts the transfer size for it's
exec_op hook. The size limit between exec_op and transfer_one_message
can be different. (this spi-mtk-nor is an example of that.)
-- 
Regards,
Chuanhong Guo

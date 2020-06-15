Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A881F980A
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730075AbgFONOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:14:18 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE59C061A0E;
        Mon, 15 Jun 2020 06:14:18 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d15so11462819edm.10;
        Mon, 15 Jun 2020 06:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hoe1lXHz4lKZEZWxALVVm7EeK75wQDMgw9CuNYa22E4=;
        b=mRHkqBfGzvjS5MN0mIalMBwAiLvKGGSwHFzRyAUGJatUuWOcrNnauo6g/vlGtjG2Zw
         T9D7scPtJqPVxImIbY2ixXYk0vkVcj3c4fxxFP9qFG5CJznU98Km6VpQc47wKrQZbDit
         vn7f849qwhSezsnbRNiF9Av8fiIfJt+PdujN8+TfpNZtbvd4Doj+AEO9H1N+y5JFR0cp
         PBEoumUEMSZ6ReF7dZaYaukK3SRdCh3GkUcz3D7fQ8Bn+ud2o9GLRM4tQZ7Zmgh2qFjP
         xAPxzRRx4IuY+7H7juMMBK4yvR9JHnBmMmmoqZiah5oftCTteulN5M7FC4UfzTKRC0uN
         9oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hoe1lXHz4lKZEZWxALVVm7EeK75wQDMgw9CuNYa22E4=;
        b=NAI9aP7bq1dSwzRWEPRHW5KOlxqETm5ucrhf+f5yaahLwDTb3hRZwoLEUJxn/RZsm4
         Rwt5Kpi4Us4HzOsqcc8a/SklnYcCUdCZH+53/eD1SIb4U8scf3H0Gbr54cqpi7PJPf9b
         H2xdLhMfBypqH2zBl5pFq+qYmJ20F9+4YoCwVl/FJdvt3pD85BJfu7mp8Xmuf4ofSlya
         wvi4V/Vd55wSw6c2YXzTUfDttxsLTEHJIR186UfLwZfnCJupDzXAe6kAwA9If26x6Y2U
         vMi7Ze8QwTGvDUb3FbY71hrgy1HKVvxZRHGgFFiDXqIXF5etPskX5qx3QEsTBfQtjuMK
         4bLw==
X-Gm-Message-State: AOAM532MzWGOkO613LdBbzC/W7R9QJZ1ZSdqZNkBA62/oUH4fEXXXfSe
        gIOBJ+y7EtmjlKBnjE3myqON5EFWBQlrjZqg9y0tAA==
X-Google-Smtp-Source: ABdhPJxwRsEHd4iu3rG/WDGzWd+fAUKrQi0ii59nBmgSbCTS5aOlqQ2+aqYluP4P4vmBh6BBoQOTRhUI/s/CzZCs1sY=
X-Received: by 2002:a05:6402:545:: with SMTP id i5mr24203132edx.179.1592226857370;
 Mon, 15 Jun 2020 06:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com> <20200615131012.GB2634@kozik-lap>
In-Reply-To: <20200615131012.GB2634@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 16:14:06 +0300
Message-ID: <CA+h21hoCUC-UqHKLOsMhiEZdyTctUwNC6pqijpD9X96ZZq4M7w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 16:10, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>

>
> It is a slightly different bug which so this patch should have a follow
> up.
>
> Best regards,
> Krzysztof
>

Why is it a different bug? It's the same bug.

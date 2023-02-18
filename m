Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5586D69BA70
	for <lists+stable@lfdr.de>; Sat, 18 Feb 2023 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBROcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Feb 2023 09:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBROcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Feb 2023 09:32:31 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0403A1814E
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 06:32:31 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id w5so2739999vsl.6
        for <stable@vger.kernel.org>; Sat, 18 Feb 2023 06:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676730750;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HsSiaeMeX2XPaDsQmxEi7VHxP7m3DaMlX3tfIQJA81Q=;
        b=B6GILMA4tzLis5rUxpSL1SQjs7GZpkmtsZ47gwtNYDNBw7wXNcel/OKu0EnNc7TPEK
         diQX/M688mHvoyhbwEO+uQOpGkgeARRSMrJpF1bWC/MPeYsCC46SUWsgFEMYTB68YjBe
         w8bf6AGT7SEdOuoJ+nNMffJojFNDAemaQh40kfjWNkB7Hn4mnfWVqutlGT20uPeRYBMl
         gk3Ty8kIIpto8/XCmoW4S0nrjJufZZD38nKAY02b6+KS/PYvBpt7v43+dnQwQEhR4mU0
         RyE2UC42LtaBOtPuss9paQQM3BKh1vCWf+gp/xNvPVzlllvJGcJOVNPfwhi95XIF+vEP
         7DCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676730750;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HsSiaeMeX2XPaDsQmxEi7VHxP7m3DaMlX3tfIQJA81Q=;
        b=BpaOBfI80Y416ItmxutmH1DFfujSomlYX7Eb8FHTTDhqdNHJJIAIL0BNinlCQpuDei
         DPWPT0GAJwHgS0rWDWMsoQJEJUytOEoOL5xxE5dGlrNdD7bDxiC/AvzWljIxdZ9F/rUd
         aLyLruFgqVIe17HeohzRPHbZdrbQbIwANODa4oHIvKYDB4O84pZ1BiOLFtX7CaMuyeAq
         V5MkKxUzRkKy9xQCysEd0sMs5ooY0ePPOb/q03yAZEmkV4pIJkV7o5yFEQ5hphD9JtLm
         V0CxbNYI48id06kdPF/ItpkGdDQYV4nplpwTM2IpEqEjFWoN8IlPA2cNFrTNzRSElDV5
         S3RA==
X-Gm-Message-State: AO0yUKVHqeRU3WtnQiCUCcx+eThcTAoKwPEasFICLllNhgTCzVHAQkWE
        Lwq4aViCa6KxNALlmZA78gZ3qCFPHo5ZMq7B/NU=
X-Google-Smtp-Source: AK7set+SxwwVpAgR9+pcAXy5OBvzcMa6xstnKIABDRKlpVBWdUvzEJwGwVKAhxs5OA2qqgGMbI4wato/oEQ91uI7MWs=
X-Received: by 2002:a05:6102:3107:b0:404:8967:82d0 with SMTP id
 e7-20020a056102310700b00404896782d0mr103658vsh.61.1676730749919; Sat, 18 Feb
 2023 06:32:29 -0800 (PST)
MIME-Version: 1.0
References: <16767073279675@kroah.com> <20230218142350.2548-1-konishi.ryusuke@gmail.com>
 <20230218142350.2548-2-konishi.ryusuke@gmail.com>
In-Reply-To: <20230218142350.2548-2-konishi.ryusuke@gmail.com>
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date:   Sat, 18 Feb 2023 23:32:13 +0900
Message-ID: <CAKFNMomsAL9ueaUsgvKtUszd5kjrTb=4fcjNWL9SmLo4VbFNmg@mail.gmail.com>
Subject: Re: [PATCH 5.10 5.15] nilfs2: fix underflow in second superblock
 position calculations
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        syzbot+f0c4082ce5ebebdac63b@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, duplicate patch submission.  Ignore the second one as it is the same.

Thanks,
Ryusuke Konishi

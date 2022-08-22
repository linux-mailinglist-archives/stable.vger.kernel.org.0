Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84E959BDF4
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 12:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiHVKzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 06:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbiHVKzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 06:55:02 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114EB24956
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:55:01 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id bn9so2653565ljb.6
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 03:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc;
        bh=W38wILXAOsLN0spW4/FTEOVGT/u6x1Em51eO6WN6vgg=;
        b=DkFquB5oGi8PxD3QMIzalB5Btd/qoO0K+eVIuFfecSAxQK9gjHfnSo8Aj0NmDLGNhw
         tI8+QAW9OYwEWF/vnWL320/yN26Jlt/33rfLjlmQ83kUEETsH3znCynPnEmv2T5nk8vg
         s+BDmpkyRYP/Eu+hBBR1j0sRig/pMjhP0pB0MK2FVzpRJ2RWJlcYik53J3BhKEQ0ToAb
         XsCtu2HbH15/AccTAXZXMdxCkftPoKUUpUOn83RzOV0r94XAJpR781nOPcKMvrBVtUgs
         EXElV5WQdIdrjPjvwk/rw6aKL9oDyYiDVcF86Mez3MInhedEKpQCa3RzpC66J2nEgZdd
         cpyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc;
        bh=W38wILXAOsLN0spW4/FTEOVGT/u6x1Em51eO6WN6vgg=;
        b=YdUP7FUk8EFTgX+FQDJ89sCZio8kBnClhFUSNsvvWgCys5YDYIOkJxezrd38vvJPEj
         AJXafUe3fVU/PbJcSK4Br3PIUYLCdEgp92oJLu6rEL6/9F8hX/TOlcBMpfq7qLYDak2j
         RtLGaKTte6k1TMiXe+PrfEuLvQuXe9TUsSLV0/NQeKpKI3hKPaEwMFJHlrPj85EJvwsG
         0RmdJOQgWiHDJcB7AQKJPW6Tjm6IeEiF4DB3DXSLfz/im81XkdsNdxCDvkBRhxC2L/EQ
         qWTXNNU8sNjdfpV2NA76hy2+/Uqg5uPTcxXYQAqfWUl6tWAJXZ9UaBaxDlOErAGSUH5e
         gOVA==
X-Gm-Message-State: ACgBeo23yU0njf47V9yROed+uEKAMX/GU8K4fmYxO5nVeauGc6wsuySd
        Zl8sTsNylxG6sZb1InFXR38EYfs3yN0=
X-Google-Smtp-Source: AA6agR6NcJNW5TuUgLFSy+fNGIUnxXY4JenRWljsWqdLJMslXXz7Go48DyiGRh1z7+yQikwjXwxpIA==
X-Received: by 2002:a2e:540e:0:b0:261:d12d:8618 with SMTP id i14-20020a2e540e000000b00261d12d8618mr759178ljb.459.1661165698994;
        Mon, 22 Aug 2022 03:54:58 -0700 (PDT)
Received: from smtpclient.apple ([80.87.144.137])
        by smtp.gmail.com with ESMTPSA id q15-20020a056512210f00b00492d1eb41dfsm1196513lfr.240.2022.08.22.03.54.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Aug 2022 03:54:56 -0700 (PDT)
From:   Alexander Kochetkov <al.kochet@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: [PATCH] Fix ethernet for rk3188 for 4.19, 5.4 stable
Message-Id: <512449D6-77E3-4FD5-A719-85DC186C4871@gmail.com>
Date:   Mon, 22 Aug 2022 13:54:55 +0300
To:     stable@vger.kernel.org
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please apply to 4.19, 5.4 stable following:

commit	ef990bcad58cf1d13c5a49191a2c2342eb8d6709

clk: rockchip: add sclk_mac_lbtest to rk3188_critical_clocks
Since the loopbacktest clock is not exported and is not touched in the
driver, it has to be added to rk3188_critical_clocks to be protected from
being disabled and in order to get the emac working.

Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: 
https://lore.kernel.org/r/20200722161820.5316-1-knaerzche@gmail.com

Signed-off-by: Heiko Stuebner <heiko@sntech.de>


Thanks,
Alexander.


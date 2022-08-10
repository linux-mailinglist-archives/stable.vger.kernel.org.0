Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5329C58EFD7
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbiHJP4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 11:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiHJP4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 11:56:09 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD998FD74
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:54:11 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-32269d60830so147200667b3.2
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=7uOVjNbrgSfE2ciynfpsfL1p/j5ggpJQvzClc88G+yA=;
        b=QytUwZFV4FXBsVtLw82bS4+zPuakCyTVTz1yv3/TW5RSqjnwhM/VV1BfcCMbLtsqEB
         EN4gbQ7fjVTrM1CH+7HPZkhvETxN/jPy0JnP6l/DpOyS5yfx9/Al8HpgBbueDzsM7fco
         If/ZUwCCRIa2Ez3zBnSkWEpRTuPdTsmfjtczpxbyoLEtyjigZjVXpP6SpVzxJqTX54zy
         CQn1VOZyQXU01Se+7dNYT0lwxZobUDFMyTeHSKfi5WPmIejkKygIH8f44reN0pZdhCjl
         CaQ16iRpnvfcanA+hDQ8TYGy7A7tbSYaHwdyklYYrzbpjewYr88+gixfgMM07LV4dEBr
         Xt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=7uOVjNbrgSfE2ciynfpsfL1p/j5ggpJQvzClc88G+yA=;
        b=tM37F3uFoLVtmPG7YeCs4yHpnYkqwfaCb3wrRo0dSEtj01k1uPB72+9I0Bb77BBYAa
         q2ArsnzFrv7cbJS/csrjBPK4qohCBDJEDNqX6lwfcHcmHirQR/Ul9inE84zqiGN872oZ
         oA/Gh34wHgKdlaZXXAacSWl8WtIG7309fgYeTCWNdLFUwuVjLLNXtxxW7PZd/z565eWB
         TLILL2beJ8H81u3FqYohFzMAsSQDTD7l9gNLDccG+q2e1Y6YUFEq9MXt6QfdNa8R4nro
         pTdK0YfD+GrSqlx/0QHXpGOMySrviSrtDBhE13AjkIUNJLsWuj7HnKPXIxUFjuCao+g9
         DSTA==
X-Gm-Message-State: ACgBeo0pFTzAgGljqkvVhO3DjBeMuVmlStqCyaGjeQrSV+XL4FkOnr7U
        m+JJiARu4gYuJMJ3n2LKRYljHf9uz91qeErGdsNCrYwaaTvVSH01
X-Google-Smtp-Source: AA6agR7n2SVGC7Kp1O8r58zL1vwJjZ2WVbXTNEg9femW+8LtW5iUWla2WRlDGSVwdGHQoDO2rrOk2iQfuNXMg5TLyFo=
X-Received: by 2002:a81:13d7:0:b0:324:7dcb:8d26 with SMTP id
 206-20020a8113d7000000b003247dcb8d26mr29267577ywt.452.1660146849636; Wed, 10
 Aug 2022 08:54:09 -0700 (PDT)
MIME-Version: 1.0
From:   Jeongik Cha <jeongik@google.com>
Date:   Thu, 11 Aug 2022 00:53:58 +0900
Message-ID: <CAE7E4gmX=L8y26DJOkUbYtP59RJDRzob5K5oi0ZLGO-EfcQMjA@mail.gmail.com>
Subject: wifi: mac80211_hwsim: fix race condition in pending packet
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, Alistair Delva <adelva@google.com>,
        JaeMan Park <jaeman@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello everyone,

I'd like to request a review to merge these patches into stable releases.

These patches fix race conditions in pending packets from
mac80211_hwsim which cause kernel panic after a device is running for
a few hours. It makes test cases in Android(which uses mac80211_hwsim
for test purposes) flaky, and also, makes Android emulator unstable.

It would be great if these patches could be merged after version 4.19.

If you have further questions, please let me know!

commit cc5250cdb43d444061412df7fae72d2b4acbdf97 wifi: mac80211_hwsim:
use 32-bit skb cookie
commit 58b6259d820d63c2adf1c7541b54cce5a2ae6073 wifi: mac80211_hwsim:
add back erroneously removed cast
commit 4ee186fa7e40ae06ebbfbad77e249e3746e14114 wifi: mac80211_hwsim:
fix race condition in pending packet

Thanks
Jeongik

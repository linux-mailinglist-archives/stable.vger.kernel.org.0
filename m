Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4406A284CB6
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 15:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgJFNwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 09:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgJFNwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 09:52:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D00C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 06:52:39 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id u17so1153069qvt.23
        for <stable@vger.kernel.org>; Tue, 06 Oct 2020 06:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=X/hCa8gN/NHhf9tV08GOABd9YPO8syQlEVjmbLlNZxg=;
        b=isiQx5iQXTXCtiesj3Zh91Pc5yqPxxZh9d5pjCs3hE5sIEpugR2UZ/WhBP01RwNLdU
         2JWjgjuCb549YeevgADXNW2wo/Hj2ZlYhqMEZSn0JObpEufY5M5rAwfO1SX9UpjHPBQ8
         bvguFlxlDeenGJ5ojkbiHoi2F8vXj1/KETP4Lhil1by4PMz/aFjODR3DuolXl54AESJf
         cQ2gsR6ht8g30wbhCgViBOL8VNAugTc7pYC1hKuph7cmqab+MDio4G37EK00PBGgIPIy
         hLjtO2pmWJdC1S5JONwDDk1/9Qxwfei0QIoofW1vPYUqxW1MrOD28TKXyOFQDuRImiPl
         VrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=X/hCa8gN/NHhf9tV08GOABd9YPO8syQlEVjmbLlNZxg=;
        b=OcgI9Y4ZljOyVDvbz9oESFaRR2DiXFcRA4BRzJlD2hMtDY6WS2g6zy0iLOP6ZLm61X
         Fxnct+xhhHKNMRfzPbIp0GVp/P0OTWLdFWn/c6mNzaWGU2x5acCe/fw/3HVqZrz8Q8Wz
         X8ce7ntK7DViN8G46+UaqmCAZoR5KIZxIG0yC6amvFWMSBTRSHFJmllIjq6yed3sYN0e
         ckCVKrfmAox6alOZ5YfAwzLN9OI5wtIwSzrcB2UZXQIjvjLbVkrq+u6I6OP8Nu9Au3tM
         48qcnNPuio5HO+D+vw+i8YPYoF1wsX0XqJpkhwr3bwe8BG3NbT6+lpq09QRd++xnDzaN
         /sqw==
X-Gm-Message-State: AOAM5325Y1YlDz2vTMJabpHvw6DQspc2pB4tweHqUCS66rGmuMacIkSV
        eSiJIx8yt/UNbTLGGv9Y1fiJuUO7c1QR2g==
X-Google-Smtp-Source: ABdhPJxHHgOhWC2FE/9GTB1/xI/detlBR/PJ1tmBkOe+EqApgRNVOlD0+zUQOmnNqWUAifZQiH2S/sbr4Sw12g==
Sender: "gprocida via sendgmr" <gprocida@tef.lon.corp.google.com>
X-Received: from tef.lon.corp.google.com ([2a00:79e0:d:110:a6ae:11ff:fe11:4f04])
 (user=gprocida job=sendgmr) by 2002:ad4:4b61:: with SMTP id
 m1mr4929747qvx.11.1601992358569; Tue, 06 Oct 2020 06:52:38 -0700 (PDT)
Date:   Tue,  6 Oct 2020 14:52:27 +0100
Message-Id: <20201006135228.113259-1-gprocida@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 0/1] Fix drm_syncobj_handle_to_fd refcount leak
From:   Giuliano Procida <gprocida@google.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is for 4.14.

Earlier LTS kernels don't have this functionality at all and later
ones have the original commit.

The code is untested as I don't have the right hardware handy.

Giuliano Procida (1):
  drm/syncobj: Fix drm_syncobj_handle_to_fd refcount leak

 drivers/gpu/drm/drm_syncobj.c | 1 -
 1 file changed, 1 deletion(-)

-- 
2.28.0.806.g8561365e88-goog


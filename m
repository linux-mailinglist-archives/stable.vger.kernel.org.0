Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8D668B795
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 09:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBFInV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 03:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjBFInA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 03:43:00 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B863F1E5F7
        for <stable@vger.kernel.org>; Mon,  6 Feb 2023 00:42:32 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id z13so604785wmp.2
        for <stable@vger.kernel.org>; Mon, 06 Feb 2023 00:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XB56ReBTUPACcJGAKGiDdljlbrakSxaa+sKCXU5oXMU=;
        b=Vn10BSiy6jAq/2gf2LFgV2ng9XowMqLwLRsYWG/uRPcSMeVC6ZxTPq9WxeZzTDJjSU
         APfOIRcjVdz/TxJhAWC5imiAFjV/+i5l+JWsQBD1AntodJ+POsUJ/7+PYkgkJXtjuljh
         mLWwIUKq8HVESDoYmGSvyKV8oNKvdOZkhZn0tQy8NkRiNQldIwtGuJcVW6Mr+UKe2BXE
         pP/hgkVu14+t1WXIXmYg3xIseSpOmxjuPrp89MQLe1Q0z2uv1gwUdWxffmNpZbmuQZHr
         ObiaAnr4gGSvv5dmLQv9L2fZDRr72rm0W90IixFO/H4AyrKfe/NSy2ntdrjY2nQvEXtu
         6FIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XB56ReBTUPACcJGAKGiDdljlbrakSxaa+sKCXU5oXMU=;
        b=lLmTmR9Yu/3K7yOeXjGhA0WtmFXD35JEbEZO+xV2XgBzZq92/3n1K0v4hX2BE+RLEr
         IQvRjpMT/2fOeHgbDLNkc3tnYB6EILzCFJbGE229Smo5yGEddeUaW4qhItehoP0cZSsS
         4XZUZKhKnAsbFpvqqJHuSLxPUlMAXMsWG8p0YWtj9kOez3057ElrFpGR/HNPsaW+n50l
         MrmrVSEeEHGCyYywJQRB5d0DszNEXKJTRkuVQ9G6RqNXoSpTYbqZwcs8DTn+2IwyxJI4
         F4zYaUtf2TKzJCwfmLksASNA8uocKZOwYHMGSUEzt3BBKTnkQDeuSYb7FdUMjU1h3KFn
         YBfA==
X-Gm-Message-State: AO0yUKUYpGlYuy/sgw90qtKhAadETkIkkwhVWxbjJM1qWLvNNWZ8b+Xu
        Or7rGd7i3fDUgJH84yCMit79Sw==
X-Google-Smtp-Source: AK7set/gnVYt0Sutq9CXeoTrPfgS+nkOq1IYzBux5uTgqcMKNg3gW43hYhMOIhIjOWfk5wvAJs8tkw==
X-Received: by 2002:a05:600c:3795:b0:3dc:4c4f:6dc5 with SMTP id o21-20020a05600c379500b003dc4c4f6dc5mr18561434wmr.9.1675672946989;
        Mon, 06 Feb 2023 00:42:26 -0800 (PST)
Received: from 1.. ([82.77.80.113])
        by smtp.gmail.com with ESMTPSA id h27-20020a05600c2cbb00b003db12112fcfsm11225960wmc.4.2023.02.06.00.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 00:42:26 -0800 (PST)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     pratyush@kernel.org, michael@walle.cc, lrannou@baylibre.com,
        Alexander.Stein@tq-group.com,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type
Date:   Mon,  6 Feb 2023 10:42:22 +0200
Message-Id: <167567282460.10447.5187058692284159203.b4-ty@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230203070754.50677-1-tudor.ambarus@linaro.org>
References: <20230203070754.50677-1-tudor.ambarus@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1023; i=tudor.ambarus@linaro.org; h=from:subject:message-id; bh=oJ4Zqpvnk5LS+L+rrTXXcBn8eWT4XuMF3QLF0FeS9/g=; b=owEBbQGS/pANAwAKAUtVT0eljRTpAcsmYgBj4L1ssmL5NAyuWEun1zWFxniM0RMOTMeTy/sZp I92+zmSthGJATMEAAEKAB0WIQQdQirKzw7IbV4d/t9LVU9HpY0U6QUCY+C9bAAKCRBLVU9HpY0U 6T80CAC4pYeNccEjxE/otjp2bJMD8ROqAV1KRfPnbN/Kv88zfhuEUmuIcqT5+6cPWc5ekFNnxfz nBnEJsd+437/8EW0ZvHa8t22cUianEmsDrZbo+4WaNIG/NHk6uf+V+IqVRDN3Hgz2UH1M7n/kRI Wq5sXd0I+pnH97WASvDTkY8wSlelFzVHwciJv4BMppx77/seThwJf++ljEJxOgmmg2SRCpA9dU1 wr9JhPpu0Nlu1HoOx0utLRYwkSSUUM+AeK2pg8z54WwO+smVEgCpFKAdhdJ1ZkM8W2SdGlW9rzF Wm5uMeIcUCsV0w7GPGfx4LY2xMz/j68mrT9cUqSUepN33aai
X-Developer-Key: i=tudor.ambarus@linaro.org; a=openpgp; fpr=280B06FD4CAAD2980C46DDDF4DB1B079AD29CF3D
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 03 Feb 2023 09:07:54 +0200, Tudor Ambarus wrote:
> spi_nor_set_erase_type() was used either to set or to mask out an erase
> type. When we used it to mask out an erase type a shift-out-of-bounds
> was hit:
> UBSAN: shift-out-of-bounds in drivers/mtd/spi-nor/core.c:2237:24
> shift exponent 4294967295 is too large for 32-bit type 'int'
> 
> The setting of the size_{shift, mask} and of the opcode are unnecessary
> when the erase size is zero, as throughout the code just the erase size
> is considered to determine whether an erase type is supported or not.
> Setting the opcode to 0xFF was wrong too as nobody guarantees that 0xFF
> is an unused opcode. Thus when masking out an erase type, just set the
> erase size to zero. This will fix the shift-out-of-bounds.
> 
> [...]

Applied to spi-nor/next, thanks!

[1/1] mtd: spi-nor: Fix shift-out-of-bounds in spi_nor_set_erase_type
      https://git.kernel.org/mtd/c/f0f0cfdc3a02

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@linaro.org>

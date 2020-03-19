Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7723618C2A6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 22:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbgCSV7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 17:59:22 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59566 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgCSV7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 17:59:22 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JLxIPT102792;
        Thu, 19 Mar 2020 16:59:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584655158;
        bh=AaDhPtzcI2QtHObcb78aZzBxAWoChbArkw0aB0Abv4w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kjCFhLmwgsfNbF/Uspzz8QIpMtsfzWQVIx5jV5vJqLLo8Ge8imOdix+hkGyeCsOX8
         XqURNC0dR99NoROSSv3kNBw8ZgkkTOH03pYx4z6IYlkyPmLOQilwet3tJwIaGkzuAG
         5p2glgaeeLk+Z5hViBaxVVA+s4U+9EE3Ayi9CYr8=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JLxIwm023878;
        Thu, 19 Mar 2020 16:59:18 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 16:59:18 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 16:59:17 -0500
Received: from [10.250.87.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JLxHiA036297;
        Thu, 19 Mar 2020 16:59:17 -0500
Subject: Re: [PATCH v2] media: ov5640: fix use of destroyed mutex
To:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC:     <stable@vger.kernel.org>
References: <20200313082258.6930-1-tomi.valkeinen@ti.com>
 <20200313131948.13803-1-tomi.valkeinen@ti.com>
From:   Benoit Parrot <bparrot@ti.com>
Message-ID: <1148f4ff-27a5-6b4b-125d-3bdabbe7aa6f@ti.com>
Date:   Thu, 19 Mar 2020 16:59:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200313131948.13803-1-tomi.valkeinen@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Benoit Parrot <bparrot@ti.com>

On 3/13/20 8:19 AM, Tomi Valkeinen wrote:
> v4l2_ctrl_handler_free() uses hdl->lock, which in ov5640 driver is set
> to sensor's own sensor->lock. In ov5640_remove(), the driver destroys the
> sensor->lock first, and then calls v4l2_ctrl_handler_free(), resulting
> in the use of the destroyed mutex.
> 
> Fix this by calling moving the mutex_destroy() to the end of the cleanup
> sequence, as there's no need to destroy the mutex as early as possible.
> 
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/media/i2c/ov5640.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 854031f0b64a..2fe4a7ac0592 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -3093,8 +3093,8 @@ static int ov5640_probe(struct i2c_client *client)
>  free_ctrls:
>  	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
>  entity_cleanup:
> -	mutex_destroy(&sensor->lock);
>  	media_entity_cleanup(&sensor->sd.entity);
> +	mutex_destroy(&sensor->lock);
>  	return ret;
>  }
>  
> @@ -3104,9 +3104,9 @@ static int ov5640_remove(struct i2c_client *client)
>  	struct ov5640_dev *sensor = to_ov5640_dev(sd);
>  
>  	v4l2_async_unregister_subdev(&sensor->sd);
> -	mutex_destroy(&sensor->lock);
>  	media_entity_cleanup(&sensor->sd.entity);
>  	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
> +	mutex_destroy(&sensor->lock);
>  
>  	return 0;
>  }
> 
